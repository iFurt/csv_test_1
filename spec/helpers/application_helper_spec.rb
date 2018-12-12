require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_class' do
    context 'when notice message' do
      let(:level) { :notice }
      let(:expected_class) { 'alert alert-info' }

      it 'returns info class' do
        expect(helper.flash_class(level)).to eq expected_class
      end
    end

    context 'when success message' do
      let(:level) { :success }
      let(:expected_class) { 'alert alert-success' }

      it 'returns success class' do
        expect(helper.flash_class(level)).to eq expected_class
      end
    end

    context 'when error message' do
      let(:level) { :error }
      let(:expected_class) { 'alert alert-danger' }

      it 'returns danger class' do
        expect(helper.flash_class(level)).to eq expected_class
      end
    end
  end
end
