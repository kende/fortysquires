class CreatePurchaseTokens < ActiveRecord::Migration
  def self.up
    create_table :purchase_tokens do |t|
      t.string :token
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :purchase_tokens
  end
end
