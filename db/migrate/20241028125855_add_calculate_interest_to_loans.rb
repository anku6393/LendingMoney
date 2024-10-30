class AddCalculateInterestToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :calculate_interest, :decimal, precision: 10, scale: 2, default: 0
  end
end
