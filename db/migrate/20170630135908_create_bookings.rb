class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.string :client_email
      t.integer :price
      t.date :start_at
      t.date :end_at
      t.belongs_to :rental, foreign_key: true

      t.timestamps
    end
  end
end
