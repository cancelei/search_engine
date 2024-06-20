# app/models/search_history.rb
class SearchHistory < ApplicationRecord
  belongs_to :user
  validates :query, presence: true
  validates :search_engine, presence: true
end
