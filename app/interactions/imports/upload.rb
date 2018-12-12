class Imports::Upload < BaseInteraction
  SUPPLIERS_FILE_NAME = 'suppliers.csv'
  SKU_FILE_NAME = 'sku.csv'

  file :csv_file

  def execute
    unless !!process_upload
      errors.add(:base, I18n.t('filename_is_invalid'))
    end
  end

  private

  def process_upload
    return SuppliersUploadWorker.perform_async(temp_file_path) if csv_file.original_filename == SUPPLIERS_FILE_NAME
    return SkuUploadWorker.perform_async(temp_file_path)       if csv_file.original_filename == SKU_FILE_NAME
  end

  def temp_file_path
    file_hex = SecureRandom.hex
    destination = File.new("tmp/#{file_hex}_#{csv_file.original_filename}", 'w+')
    IO.copy_stream(csv_file.path, destination.path)
    destination.path
  end
end
