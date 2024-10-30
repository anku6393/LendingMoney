module LoanConcern
  extend ActiveSupport::Concern
  include ApplicationHelper

  def repay_loan(loan)
    admin = User.find_by(is_admin: true)
    user = loan.user
    admin_wallet_balance = admin.wallet_balance
    user_wallet_balance = user.wallet_balance
    payable_amount = payable_amount(loan)

      admin_balance = admin_wallet_balance + payable_amount
      user_balance = user_wallet_balance - payable_amount

      ActiveRecord::Base.transaction do
        admin.update!(wallet_balance: admin_balance)
        user.update!(wallet_balance: user_balance)
        loan.update!(status: 'closed')
      end

      { message: 'Loan repaid successfully.', status: :ok }

  rescue ActiveRecord::RecordInvalid => e
    puts "Transaction failed: #{e.message}"
    { error: "Transaction failed: #{e.message}", status: :unprocessable_entity }
  end

end
