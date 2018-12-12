require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe '#index' do
    before do
      allow(Skus::Index).to receive(:run!).and_return(Sku.none)
    end

    it 'assigns @skus instance variable' do
      get :index
      assigns(:skus).should_not be_nil
    end

    it 'calls Skus::Index interaction' do
      expect(Skus::Index).to receive(:run!)
      get :index
    end
  end
end
