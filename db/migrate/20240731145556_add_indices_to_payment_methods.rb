class AddIndicesToPaymentMethods < ActiveRecord::Migration[7.0]
  def change
    add_index :spree_payment_methods, :active
    add_index :spree_payment_methods, :display_on
    add_index :spree_payment_methods, :environment
  end
end
