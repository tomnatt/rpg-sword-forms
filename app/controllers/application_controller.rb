class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def set_tags
    @tags = Tag.all.order(name: :asc)
  end
end
