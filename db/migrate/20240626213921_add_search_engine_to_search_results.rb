class AddSearchEngineToSearchResults < ActiveRecord::Migration[7.1]
  def change
    add_column :search_results, :search_engine, :string
  end
end
