class SkuUploadService < BaseUploadService

  def csv_upsert
    Parallel.each(CSV.foreach(csv_file_path).each_slice(BATCH_SIZE), parallel_params) do |batch|
      skus_array = batch.map do |row|
        Sku.new(outer_id: row[0], supplier_code: row[1],
          field_1: row[2], field_2: row[3], field_3: row[4], field_4: row[5], field_5: row[6], field_6: row[7], price: row[8])
      end

      Sku.import skus_array, on_duplicate_key_update: { conflict_target: [:outer_id],
        columns: [:supplier_code, :field_1, :field_2, :field_3, :field_4, :field_5, :field_6, :price] }
    end
  end
end
