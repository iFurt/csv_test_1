require 'rails_helper'

RSpec.describe Sku, type: :model do
  it { should belong_to(:supplier).with_foreign_key('supplier_code').with_primary_key('code') }
end
