class CreateSearchResults < ActiveRecord::Migration[7.1]
  def change
    create_table :search_results do |t|
      t.string :query
      t.text :results

      t.timestamps
    end
  end
end
