class SpinsController < ApplicationController
  before_action :set_date

  def show
    @ramrod = crypto.ramrod
    @dryad = crypto.dryad
  end

  private

  def set_date
    @date = Date.parse(params[:date])
  end

  def crypto
    @crypto ||= Crypto.new @date
  end
end
