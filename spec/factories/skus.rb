FactoryBot.define do
  factory :sku do
    sequence :outer_id do |n|
      "%08d" % n
    end
    supplier
    field_1 'field one'
    field_2 'field two'
    field_3 'field three'
    field_4 'field four'
    field_5 'field five'
    field_6 'field six'
    price 10.25
  end
end
