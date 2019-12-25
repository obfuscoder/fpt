require 'rails_helper'

RSpec.describe "flights/index", type: :view do
  before(:each) do
    assign(:flights, [
      Flight.create!(
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
      ),
      Flight.create!(
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
      )
    ])
  end

  it "renders a list of flights" do
    render
    assert_select "tr>td", :text => "Theater".to_s, :count => 2
    assert_select "tr>td", :text => "Airframe".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Callsign".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Mission".to_s, :count => 2
    assert_select "tr>td", :text => "Objectives".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => "Tacan Polarization".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
