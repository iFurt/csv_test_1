require 'rails_helper'

RSpec.describe Imports::Upload, type: :interaction do
  describe '#execute' do
    let(:csv_file) { double('CSV file', path: filename, original_filename: filename, rewind: nil) }
    let(:file_hex) { SecureRandom.hex }
    let(:expected_path) { "tmp/#{file_hex}_#{filename}" }

    before do
      allow(SecureRandom).to receive(:hex).and_return file_hex
      allow(IO).to receive(:copy_stream)
      allow(SkuUploadWorker).to receive(:perform_async).and_return true
      allow(SuppliersUploadWorker).to receive(:perform_async).and_return true
    end

    context 'when params are passed' do
      after do
        File.delete(expected_path) if File.exists?(expected_path)
      end

      context 'and suppliers are uploaded' do
        let(:filename) { Imports::Upload::SUPPLIERS_FILE_NAME }

        it 'calls SuppliersUploadWorker only' do
          expect(SuppliersUploadWorker).to receive(:perform_async).with(expected_path)
          expect(SkuUploadWorker).not_to receive(:perform_async)
          described_class.run(csv_file: csv_file)
        end

        it 'is valid' do
          outputs = described_class.run(csv_file: csv_file)
          expect(outputs.valid?).to be_truthy
        end
      end

      context 'and skus are uploaded' do
        let(:filename) { Imports::Upload::SKU_FILE_NAME }

        it 'calls SkuUploadWorker only' do
          expect(SuppliersUploadWorker).not_to receive(:perform_async)
          expect(SkuUploadWorker).to receive(:perform_async).with(expected_path)
          described_class.run(csv_file: csv_file)
        end

        it 'is valid' do
          outputs = described_class.run(csv_file: csv_file)
          expect(outputs.valid?).to be_truthy
        end
      end

      context 'and unknown file is uploaded' do
        let(:filename) { SecureRandom.hex }

        it 'does not call SuppliersUploadWorker' do
          expect(SuppliersUploadWorker).not_to receive(:perform_async)
          described_class.run(csv_file: csv_file)
        end

        it 'does not call SkuUploadWorker' do
          expect(SkuUploadWorker).not_to receive(:perform_async)
          described_class.run(csv_file: csv_file)
        end

        it 'is not valid' do
          outputs = described_class.run(csv_file: csv_file)
          expect(outputs.valid?).to be_falsey
        end

        it 'contains errors' do
          outputs = described_class.run(csv_file: csv_file)
          expect(outputs.errors.full_messages.join('; ')).to eq I18n.t('filename_is_invalid')
        end
      end
    end

    context 'when no params are passed' do
      it 'is not valid' do
        outputs = described_class.run
        expect(outputs.valid?).to be_falsey
      end

      it 'contains error' do
        outputs = described_class.run
        expect(outputs.errors.full_messages.join('; ')).to eq "Csv file #{I18n.t('active_interaction.errors.messages.missing')}"
      end
    end
  end
end
