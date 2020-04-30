class MdcController < ApplicationController
  def show
    @flight = Flight.current.with_pilot(params[:pilot]).first
    return head :not_found if @flight.nil?

    @loadout = @flight.parsed_loadout
    render :show, layout: false, formats: [:text]
  end
end
