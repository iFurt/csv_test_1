class SkuUploadWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(csv_file_path)
    SkuUploadService.perform(csv_file_path)
  end
end
