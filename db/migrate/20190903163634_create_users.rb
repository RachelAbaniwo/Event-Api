class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :session_id
      t.integer :event_id
      t.boolean :attended, :default => false

      t.timestamps
    end
  end
end
