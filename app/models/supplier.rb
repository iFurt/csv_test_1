class Supplier < ApplicationRecord
  has_many :skus, foreign_key: 'supplier_code', primary_key: 'code'
end
