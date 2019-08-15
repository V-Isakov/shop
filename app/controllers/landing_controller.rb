class LandingController < ApplicationController
  def index
  end

  def docs
    render 'docs', layout: false
  end
end
