class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string :name
      t.integer :event_id
      t.integer :rsvp, :default => 0
      t.integer :max_rsvp, :default => 1000

      t.timestamps
    end
  end
end
