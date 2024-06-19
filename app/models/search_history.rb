# app/models/search_history.rb
class SearchHistory < ApplicationRecord
  belongs_to :user
end
