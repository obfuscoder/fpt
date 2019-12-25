require 'rails_helper'

RSpec.describe "flights/show", type: :view do
  before(:each) do
    @flight = assign(:flight, Flight.create!(
      :theater => "Theater",
      :airframe => "Airframe",
      :duration => 2,
      :callsign => "Callsign",
      :callsign_number => 3,
      :slots => 4,
      :flight => "Mission",
      :objectives => "Objectives",
      :group_id => 5,
      :laser => 6,
      :tacan_channel => 7,
      :tacan_polarization => "Tacan Polarization",
      :frequency => "9.99",
      :notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Theater/)
    expect(rendered).to match(/Airframe/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Callsign/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Mission/)
    expect(rendered).to match(/Objectives/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/Tacan Polarization/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/MyText/)
  end
end
