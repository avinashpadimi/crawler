require 'active_record'
class CreateLinkTable < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |table|
      table.string :link
      table.integer :reference_count
      table.text :query_params
      table.timestamps
    end
  end
end

