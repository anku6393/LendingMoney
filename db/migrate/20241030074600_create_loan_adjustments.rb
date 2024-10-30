class CreateLoanAdjustments < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_adjustments do |t|
      t.decimal :loan_amount
      t.decimal :loan_rate
      t.decimal :adjusted_amount
      t.decimal :adjusted_rate
      t.references :loan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
