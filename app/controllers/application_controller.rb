class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def set_tags
    @tags = Tag.order(name: :asc)
  end
end
