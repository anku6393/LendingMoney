class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.references :user, foreign_key: true, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.decimal :interest_rate, precision: 5, scale: 2, null: false
      t.string :status, default: 'requested'
      t.decimal :adjusted_amount, precision: 10, scale: 2
      t.decimal :adjusted_interest_rate, precision: 5, scale: 2
      t.boolean :adjustment_requested, default: false

      t.datetime :approved_at
      t.datetime :closed_at

      t.timestamps
    end
  end
end
