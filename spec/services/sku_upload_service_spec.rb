require 'rails_helper'

RSpec.describe SkuUploadService, type: :service do
  describe '#csv_upsert' do
    let(:data_ary) do
      [
        ['00000001', 's0229', 'field432', 'field0910', 'field1', 'field24', 'field15', 'field15', '113.79'],
        ['00000002', 's0421', 'field10', 'field0194', 'field0684', 'field24', 'field15', 'field15', '13.79'],
        ['00000003', 's0201', 'field1', 'field0214', 'field432', 'field15', 'field0684', 'field432', '1500.5']
      ]
    end
    let(:csv_file) do
      CSV.open('tmp/skus.csv', 'w+') do |csv|
        data_ary.each { |row| csv << row }
        csv
      end
    end

    before do
      allow_any_instance_of(described_class).to receive(:parallel_params).and_return({ in_processes: 0, in_threads: 0 })
    end

    it 'imports contents into DB' do
      expect { described_class.perform(csv_file.path) }.to change { Sku.count }.from(0).to(3)
    end

    it 'removes temp file' do
      expect(File).to receive(:delete).with(csv_file.path)
      described_class.perform(csv_file.path)
    end

    context 'when further imports are performed' do
      let(:data_ary_2) do
        [
          ['00000001', 's0258', 'field1235', 'field0684', 'field10', 'field1', 'field15', 'field15', '10.25'],
          ['00000013', 's0361', 'field0684', 'field432', 'field10', 'field15', 'field15', 'field15', '13.79'],
          ['00000014', 's0811', 'field1235', 'field0684', 'field0684', 'field0684', 'field0684', 'field432', '10.25']
        ]
      end
      let(:csv_file_2) do
        CSV.open('tmp/skus_2.csv', 'w+') do |csv|
          data_ary_2.each { |row| csv << row }
          csv
        end
      end

      before do
        described_class.perform(csv_file.path)
      end

      it 'imports only new entities' do
        expect { described_class.perform(csv_file_2.path) }.to change { Sku.count }.from(3).to(5)
      end

      it 'upserts entities' do
        described_class.perform(csv_file_2.path)
        expect(Sku.all.pluck(:outer_id)).to match_array (data_ary.map(&:first) + data_ary_2.map(&:first)).uniq
      end

      it 'removes temp file' do
        expect(File).to receive(:delete).with(csv_file_2.path)
        described_class.perform(csv_file_2.path)
      end
    end
  end
end
