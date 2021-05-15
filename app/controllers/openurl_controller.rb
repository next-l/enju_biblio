class OpenurlController < ApplicationController
  skip_after_action :verify_authorized

  def index
    if params['rft.isbn']
      redirect_to manifestations_url(query: "isbn_sm:#{params['rft.isbn']}")
    end
  end
end
