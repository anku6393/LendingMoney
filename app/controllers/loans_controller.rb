# app/controllers/loans_controller.rb
class LoansController < ApplicationController
  include ApplicationHelper
  include LoanConcern

  before_action :set_loan, only: [:approve, :reject, :readjust]


  def index
    @loans = current_user.loans
  end

  def new
    @loan = Loan.new
  end

  def show
    @loan = find_loan(params[:id])
    @adjustment_history = @loan.loan_adjustments
  end

  def create
    @loan = current_user.loans.new(loan_params)
    if @loan.save
      flash[:notice] = 'Loan request created successfully.'
      redirect_to dashboard_path
    else
      flash[:alert] = 'Failed to create loan request.'
      render :new
    end
  end


  def edit
    @loan = find_loan(params[:id])
    if @loan.nil?
      flash[:alert] = 'You are not authorized to edit this loan.'
      redirect_to dashboard_path
    end
  end

  def update
    @loan = find_loan(params[:id])

    if @loan.nil?
      flash[:alert] = 'You are not authorized to update this loan.'
      redirect_to dashboard_path and return
    end

    @loan.loan_adjustments.create(loan_amount: @loan.amount, loan_rate: @loan.interest_rate, adjusted_amount: params[:loan][:amount], adjusted_rate: params[:loan][:interest_rate])

    if @loan.update(loan_params)
      @loan.update(status: 'waiting_for_adjustment_acceptance')
      flash[:notice] = 'Loan updated successfully.'
      redirect_to dashboard_path
    else
      flash[:alert] = 'Failed to update loan.'
      render :edit
    end
  end

   # Approve loan
   def approve
    if current_user
      @loan.update(status: 'approved')
      render json: { message: 'Loan approved successfully, accept request is sent to user.' }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  # Reject loan
  def reject
    if current_user
      @loan.update(status: 'rejected')
      render json: { message: 'Loan rejected.' }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  # Readjust loan
    def readjust
      if current_user
        @loan.update(status: 'readjustment_requested')
        render json: { message: 'Loan readjustment request sent to admin successfully.' }, status: :ok
      else
        render json: { error: 'Unauthorized' }, status: :forbidden
      end
    end


# accept admin request
  def accept
    admin = User.find_by(is_admin: true)
    admin_wallet_balance = admin.wallet_balance
    user_wallet_balance = current_user.wallet_balance
    loan = Loan.find(params[:id])

    if admin_wallet_balance > loan.amount
      admin_balance = admin_wallet_balance - loan.amount
      user_balance = user_wallet_balance + loan.amount

      ActiveRecord::Base.transaction do
        admin.update!(wallet_balance: admin_balance)
        current_user.update!(wallet_balance: user_balance)
        loan.update!(status: 'open', interest_calculated_at: Time.current)

      end

      render json: { message: "Loan accepted successfully amount is added to your account sucessfully." }, status: :ok
    else
      render json: { error: 'Low balance, loan cannot be accepted' }, status: :forbidden
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: "Transaction failed: #{e.message}" }, status: :unprocessable_entity
  end


# Close the loan
  def repay
    loan = Loan.find(params[:id])
    result = repay_loan(loan)

    render json: { message: result[:message] || result[:error] }, status: result[:status]
  end


  private

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate)
  end

  def find_loan(loan_id)
    if current_user.is_admin
      Loan.find_by(id: loan_id)
    else
      current_user.loans.find_by(id: loan_id)
    end
  end

  def set_loan
    @loan = Loan.find(params[:id])
  end
end
