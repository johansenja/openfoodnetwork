class AddIndicesToShippingMethods < ActiveRecord::Migration[7.0]
  def change
    add_index :spree_shipping_methods, :display_on
  end
end
