require 'rails_helper'

RSpec.describe 'flights', type: :system do
  it 'shows list of flights' do
    visit '/'

    expect(page).to have_text('Listing flights')
  end

  it 'creates new flight' do
    visit '/'

    click_link 'New Flight'
    click_button 'Save'
    expect(page).to have_text('Listing flights')
  end
end
