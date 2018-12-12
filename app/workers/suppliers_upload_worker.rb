class SuppliersUploadWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(csv_file_path)
    SuppliersUploadService.perform(csv_file_path)
  end
end
