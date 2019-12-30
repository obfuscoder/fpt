class FlightsController < ApplicationController
  before_action :set_flight, only: %i[show edit update destroy print clone]

  def index
    @flights = params['all'] ? Flight.all : Flight.current
    @all = params['all'] ? true : false
  end

  def show; end

  def new
    @flight = Flight.new theater: Settings.theaters.first.first,
                         start_airbase: Settings.theaters.first.last.airbases.first.first,
                         land_airbase: Settings.theaters.first.last.airbases.first.first,
                         departure: Settings.theaters.first.last.airbases.first.last.departures.first.first,
                         recovery: Settings.theaters.first.last.airbases.first.last.recoveries.first.first
  end

  def edit; end

  def create
    @flight = Flight.new(flight_params)

    if @flight.save
      redirect_to @flight, notice: 'Flight was successfully created.'
    else
      render :new
    end
  end

  def update
    p = flight_params
    if @flight.update(p)
      redirect_to @flight, notice: 'Flight was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @flight.destroy
    redirect_to flights_url, notice: 'Flight was successfully destroyed.'
  end
  
  def clone
    src_flight = @flight
    @flight = src_flight.dup
    @flight.start = Date.tomorrow
    @flight.save!
    src_flight.waypoints.each do |wp|
      new_wp = wp.dup
      new_wp.flight = @flight
      new_wp.save!
    end
    redirect_to edit_flight_path(@flight), notice: 'Flight successfully cloned.'
  end

  def print
    send_data create_pdf, filename: "mission_#{@flight.id}.pdf", type: 'application/pdf', disposition: :inline
  end

  def print_images
    pdf = create_pdf

  end

  private

  def set_flight
    @flight = Flight.find(params[:id])
  end

  def flight_params
    params.require(:flight).permit(:theater, :airframe, :ao, :start, :duration, :callsign, :callsign_number, :slots, :mission, :task, :group_id, :laser, :tacan_channel, :tacan_polarization, :frequency, :notes, :start_airbase, :land_airbase, :divert_airbase, :departure, :recovery, :divert, :radio1, :radio2, :radio3, :radio4, support: [])
  end
end

  private

  def create_pdf
    mdc = MissionDataCard.new @flight
    combine_pdf = CombinePDF.parse mdc.render
    combine_pdf << CombinePDF.load(Rails.root.join('public', @flight.theater, @flight.start_airbase, 'ad.pdf'))
    combine_pdf << CombinePDF.load(Rails.root.join('public', @flight.theater, @flight.start_airbase, 'departures', "#{@flight.departure}.pdf"))
    combine_pdf << CombinePDF.load(Rails.root.join('public', @flight.theater, @flight.land_airbase, 'recoveries', "#{@flight.recovery}.pdf"))
    combine_pdf << CombinePDF.load(Rails.root.join('public', @flight.theater, @flight.land_airbase, 'ad.pdf')) if @flight.start_airbase != @flight.land_airbase
    if @flight.divert_airbase
      combine_pdf << CombinePDF.load(Rails.root.join('public', @flight.theater, @flight.divert_airbase, 'recoveries', "#{@flight.divert}.pdf"))
      combine_pdf << CombinePDF.load(Rails.root.join('public', @flight.theater, @flight.divert_airbase, 'ad.pdf'))
    end
    combine_pdf.to_pdf
  end
