require 'zip'

class FlightsController < ApplicationController
  before_action :set_flight, only: %i[show edit update destroy print print_images clone]

  def index
    set_all_flights if params['all'].present?
    @flights = all_flights? ? Flight.all : Flight.current
    @all = all_flights?
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
    if @flight.update(flight_params)
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
    @flight.start = Date.tomorrow if @flight.start.past?
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
    images = Magick::Image.from_blob(create_pdf) do
      self.density = '300'
      self.colorspace = Magick::RGBColorspace
    end
    stringio = ::Zip::OutputStream.write_buffer do |zip|
      images.each_with_index do |image, index|
        image.resize! 540*2, 814*2
        image.alpha Magick::RemoveAlphaChannel
        image.format = 'png'
        zip.put_next_entry sprintf('mdc_%d_%02d.png', @flight.id, index + 1)
        zip.write image.to_blob
      end
    end
    stringio.rewind
    send_data stringio.sysread, filename: "mission_#{@flight.id}.zip", type: 'application/zip'
  end

  def defaults
    blank?
    callsign = [params[:cs], params[:n]].select(&:present?).join('_').downcase
    @defaults = Settings.theaters[params[:t]].defaults[callsign]
    render json: @defaults
  end

  private

  def set_flight
    @flight = Flight.find(params[:id])
  end

  def flight_params
    params.require(:flight).permit(:theater, :airframe, :ao, :start, :duration, :callsign, :callsign_number, :slots, :mission, :task, :group_id, :laser, :tacan_channel, :tacan_polarization, :frequency, :notes, :start_airbase, :land_airbase, :divert_airbase, :departure, :recovery, :divert, :radio1, :radio2, :radio3, :radio4, support: [])
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

  def all_flights?
    session[:all_flights] ? true : false
  end

  def set_all_flights
    session[:all_flights] = ActiveModel::Type::Boolean.new.cast params[:all]
  end
end
