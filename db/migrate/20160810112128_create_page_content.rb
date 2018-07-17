class CreatePageContent < ActiveRecord::Migration[4.2]
  def change
    create_table :page_contents do |t|
      t.string :url
      t.text :h1_data
      t.text :h2_data
      t.text :h3_data
      t.text :links
      t.timestamps
    end
  end
end
