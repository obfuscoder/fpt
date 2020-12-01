class ApplicationController < ActionController::Base
  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end
end
