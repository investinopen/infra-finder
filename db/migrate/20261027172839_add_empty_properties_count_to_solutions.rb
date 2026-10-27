# frozen_string_literal: true

class AddEmptyPropertiesCountToSolutions < ActiveRecord::Migration[8.1]
  def change
    add_column :solutions, :empty_properties_count, :integer
  end
end
