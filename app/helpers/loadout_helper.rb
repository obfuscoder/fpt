module LoadoutHelper
  def station_options(station, selected_value)
    data = station.grouped_options.map do |k, v|
      [
        Settings.payload.types[k],
        v.map do |o|
          [o.text, o.value, { data: { weight: o.weight } }]
        end
      ]
    end
    grouped_options_for_select data, selected_value, prompt: 'Empty'
  end
end
