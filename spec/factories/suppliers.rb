FactoryBot.define do
  factory :supplier do
    sequence :code do |n|
      's' + "%04d" % n
    end
    name 'Some name'
  end
end
