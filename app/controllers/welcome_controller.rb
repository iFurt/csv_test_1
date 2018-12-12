class WelcomeController < ApplicationController
  def index
    @skus = Skus::Index.run!(params)
  end
end
