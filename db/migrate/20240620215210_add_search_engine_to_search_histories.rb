class AddSearchEngineToSearchHistories < ActiveRecord::Migration[7.1]
  def change
    add_column :search_histories, :search_engine, :string
  end
end
