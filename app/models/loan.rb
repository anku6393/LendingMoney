# app/models/loan.rb
class Loan < ApplicationRecord
  belongs_to :user
  has_many :loan_adjustments, dependent: :destroy

  validates :amount, :interest_rate, presence: true
  validates :status, inclusion: { in: %w(requested approved rejected open closed waiting_for_adjustment_acceptance readjustment_requested) }


  def indian_time_zone
    created_at.in_time_zone('Asia/Kolkata').strftime('%d-%m-%Y %H:%M')
  end

end
