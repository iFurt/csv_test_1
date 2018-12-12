require 'rails_helper'

RSpec.describe Skus::Index, type: :interaction do
  describe '#execute' do
    before { create_list(:sku, 80) }

    context 'when page is not defined explicitly' do
      it 'returns first 25 results' do
        expect(described_class.run!.ids).to eq Sku.limit(25).ids
      end
    end

    context 'when the second page' do
      let(:params) { { page: 2 } }
      it 'returns second 25 results' do
        expect(described_class.run!(params).ids).to eq Sku.offset(25).limit(25).ids
      end
    end
  end
end
