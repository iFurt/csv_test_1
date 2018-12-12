FactoryBot.define do
  factory :supplier do
    sequence :code { |n| 's' + "%04d" % n }
    name 'Some name'
  end
end
