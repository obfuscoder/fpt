module LoadoutHelper
  def station_options(station, selected_value)
    data = station.grouped_options.map do |k, v|
      [
        Settings.payload.types[k],
        v.map do |o|
          data = { weight: o.weight, fuel: o.fuel }.compact
          [o.text, o.value, { data: data }]
        end
      ]
    end
    grouped_options_for_select data, selected_value, prompt: 'Empty'
  end
end
