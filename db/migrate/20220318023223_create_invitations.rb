class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :friend_id, null: false, foreign_key: {to_table: :users}
      t.boolean :confirmed

      t.timestamps
    end
  end
end
