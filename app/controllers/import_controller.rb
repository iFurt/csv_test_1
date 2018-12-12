class ImportController < ApplicationController
  def upload
    outputs = Imports::Upload.run(params)
    if outputs.valid?
      flash[:success] = I18n.t('.upload_success')
    else
      flash[:error] = I18n.t('.upload_failed', errors: outputs.errors.full_messages.join('; '))
    end
    redirect_to root_path
  end
end
