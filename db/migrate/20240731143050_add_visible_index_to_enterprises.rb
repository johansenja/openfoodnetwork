class AddVisibleIndexToEnterprises < ActiveRecord::Migration[7.0]
  def change
    add_index :enterprises, :visible
  end
end
