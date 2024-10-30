class InterestCalculatorWorker
  include Sidekiq::Worker
  include LoanConcern

  def perform
    Loan.where("status = ? AND interest_calculated_at < ?", 'open', 5.minutes.ago).each do |loan|
      interest = calculate_interest(loan)
      total_interest = loan.calculate_interest + interest
      loan.update(calculate_interest: total_interest, interest_calculated_at: Time.current)
      user = loan.user
      payable_amount = loan.amount + loan.calculate_interest

      if user.wallet_balance < payable_amount
        repay_loan(loan)
      end

      puts "<-------- interest calculated for loan where base amount ₹#{loan.amount} , interest rate is #{loan.interest_rate}% and interest for this cycle is ₹#{interest}----------->"

    end
  end

  private

  def calculate_interest(loan)
    rate = loan.interest_rate
    amount = loan.amount
    interest_amount = amount * (rate/100)
  end

end
