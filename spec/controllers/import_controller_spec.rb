require 'rails_helper'

RSpec.describe ImportController, type: :controller do
  describe '#upload' do
    context 'when upload succeeded' do
      before do
        allow(Imports::Upload).to receive_message_chain(:run, :valid?).and_return(true)
      end

      it 'assigns successful flash message' do
        post :upload
        expect(flash[:success]).to eq I18n.t('.upload_success')
      end

      it 'redirects to root path' do
        resp = post :upload
        expect(resp).to redirect_to(root_path)
      end
    end

    context 'when upload failed' do
      let(:error_msgs) { ['Ooops', 'therer was', 'error'] }
      before do
        allow(Imports::Upload).to receive_message_chain(:run, :valid?).and_return(false)
        allow(Imports::Upload).to receive_message_chain(:run, :errors, :full_messages).and_return(error_msgs)
      end

      it 'assigns failed flash message' do
        post :upload
        expect(flash[:error]).to eq I18n.t('.upload_failed', errors: error_msgs.join('; '))
      end

      it 'redirects to root path' do
        resp = post :upload
        expect(resp).to redirect_to(root_path)
      end
    end
  end
end
