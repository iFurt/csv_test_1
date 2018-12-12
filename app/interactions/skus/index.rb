class Skus::Index < BaseInteraction
  integer :page, default: 1

  def execute
    Sku.page(page)
  end
end
