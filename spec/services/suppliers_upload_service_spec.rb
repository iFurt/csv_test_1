require 'rails_helper'

RSpec.describe SuppliersUploadService, type: :service do
  describe '#csv_upsert' do
    let(:data_ary) { [['s0001', 'Supplier 1'], ['s0002', 'Supplier 2'], ['s0003', 'Supplier 3']] }
    let(:csv_file) do
      CSV.open('tmp/suppliers.csv', 'w+') do |csv|
        data_ary.each { |row| csv << row }
        csv
      end
    end

    before do
      allow_any_instance_of(described_class).to receive(:parallel_params).and_return({ in_processes: 0, in_threads: 0 })
    end

    it 'imports contents into DB' do
      expect { described_class.perform(csv_file.path) }.to change { Supplier.count }.from(0).to(3)
    end

    it 'removes temp file' do
      expect(File).to receive(:delete).with(csv_file.path)
      described_class.perform(csv_file.path)
    end

    context 'when further imports are performed' do
      let(:data_ary_2) { [['s0004', 'Supplier 4'], ['s0005', 'Supplier 5'], ['s0001', 'Supplier First']] }
      let(:csv_file_2) do
        CSV.open('tmp/suppliers_2.csv', 'w+') do |csv|
          data_ary_2.each { |row| csv << row }
          csv
        end
      end

      before do
        described_class.perform(csv_file.path)
      end

      it 'imports only new entities' do
        expect { described_class.perform(csv_file_2.path) }.to change { Supplier.count }.from(3).to(5)
      end

      it 'upserts entities' do
        described_class.perform(csv_file_2.path)
        expect(Supplier.all.pluck(:code)).to match_array (data_ary.map(&:first) + data_ary_2.map(&:first)).uniq
      end

      it 'removes temp file' do
        expect(File).to receive(:delete).with(csv_file_2.path)
        described_class.perform(csv_file_2.path)
      end
    end
  end
end
