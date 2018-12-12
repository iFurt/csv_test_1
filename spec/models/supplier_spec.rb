require 'rails_helper'

RSpec.describe Supplier, type: :model do
  it { should have_many(:skus).with_foreign_key('supplier_code').with_primary_key('code') }
end
