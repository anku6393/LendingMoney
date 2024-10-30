module ApplicationHelper

  def payable_amount(loan)
    amount = loan.amount + loan.calculate_interest
  end
  
end
