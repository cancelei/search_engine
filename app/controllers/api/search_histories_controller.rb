module Api
  class SearchHistoriesController < ApplicationController
    def index
      @search_histories = SearchHistory.all
      render json: @search_histories
    end
  end
end
