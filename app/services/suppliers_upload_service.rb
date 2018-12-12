class SuppliersUploadService < BaseUploadService

  def csv_upsert
    Parallel.each(CSV.foreach(csv_file_path).each_slice(BATCH_SIZE)) do |batch|
      suppliers_array = batch.map do |row|
        Supplier.new(code: row[0], name: row[1])
      end

      Supplier.import suppliers_array, on_duplicate_key_update: { conflict_target: [:code], columns: [:name] }
    end
  end
end
