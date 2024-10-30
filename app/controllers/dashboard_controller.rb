class DashboardController < ApplicationController

  def index
    if current_user.is_admin?
      @loans = Loan.all
    else
      @loans = current_user.loans
    end
    @wallet_balance = current_user.wallet_balance
  end


  def filter
    @loans = params[:status] == 'all' ? Loan.all : Loan.where(status: params[:status])
    @status = params[:status]
  end

end
