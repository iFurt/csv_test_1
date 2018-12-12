require 'csv'

class BaseUploadService
  BATCH_SIZE = 1000

  attr_reader :csv_file_path, :parallel_params

  def self.perform(*args)
    new(*args).perform
  end

  def initialize(csv_file_path, in_threads: nil, in_processes: nil)
    @csv_file_path = csv_file_path
    @parallel_params = { in_threads: in_threads, in_processes: in_processes }.compact
  end

  def perform
    begin
      csv_upsert
    ensure
      File.delete(csv_file_path) if File.exist?(csv_file_path)
    end
  end

  def csv_upsert
    raise 'Override me'
  end
end
