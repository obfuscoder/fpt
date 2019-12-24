require 'rails_helper'

RSpec.describe "flights/edit", type: :view do
  before(:each) do
    @flight = assign(:flight, Flight.create!(
      :theater => "MyString",
      :airframe => "MyString",
      :duration => 1,
      :callsign => "MyString",
      :callsign_number => 1,
      :slots => 1,
      :mission => "MyString",
      :objectives => "MyString",
      :group_id => 1,
      :laser => 1,
      :tacan_channel => 1,
      :tacan_polarization => "MyString",
      :frequency => "9.99",
      :notes => "MyText"
    ))
  end

  it "renders the edit flight form" do
    render

    assert_select "form[action=?][method=?]", flight_path(@flight), "post" do

      assert_select "input[name=?]", "flight[theater]"

      assert_select "input[name=?]", "flight[airframe]"

      assert_select "input[name=?]", "flight[duration]"

      assert_select "input[name=?]", "flight[callsign]"

      assert_select "input[name=?]", "flight[callsign_number]"

      assert_select "input[name=?]", "flight[slots]"

      assert_select "input[name=?]", "flight[mission]"

      assert_select "input[name=?]", "flight[objectives]"

      assert_select "input[name=?]", "flight[group_id]"

      assert_select "input[name=?]", "flight[laser]"

      assert_select "input[name=?]", "flight[tacan_channel]"

      assert_select "input[name=?]", "flight[tacan_polarization]"

      assert_select "input[name=?]", "flight[frequency]"

      assert_select "textarea[name=?]", "flight[notes]"
    end
  end
end
