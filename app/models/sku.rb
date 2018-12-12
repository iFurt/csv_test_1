class Sku < ApplicationRecord
  belongs_to :supplier, foreign_key: 'supplier_code', primary_key: 'code'
end
