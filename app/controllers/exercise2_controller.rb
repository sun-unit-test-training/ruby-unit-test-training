class Exercise2Controller < ApplicationController
  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new transaction_params
    @fee = @transaction.fee
    render :new
  end

  private

  def transaction_params
    params.require(:transaction).permit(:withdrew_at, :amount, :is_holiday, :is_vip_account)
  end
end
