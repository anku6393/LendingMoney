class AddInterestCalculatedAtToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :interest_calculated_at, :datetime
  end
end
