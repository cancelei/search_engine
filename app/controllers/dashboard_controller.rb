# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_histories = current_user.search_histories.order(created_at: :desc)
  end
end
