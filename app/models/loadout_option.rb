class LoadoutOption
  def initialize(config)
    @config = config
  end

  def type
    Settings.payload[payload_id].type
  end

  def weight
    amount * weapon_weight + pylon_weight
  end

  def fuel
    Settings.payload[payload_id].fuel
  end

  def value
    result = [weapon_id, pylon_id].compact.join ','
    weapon? ? "#{amount}x#{result}" : result
  end

  def text
    result = [weapon_name, pylon_name].compact.join ' - '
    weapon? ? "#{amount}x #{result}" : result
  end

  def weapon_name
    weapon_config.name if weapon?
  end

  def pylon_name
    pylon_config.name if pylon?
  end

  private

  def weapon_weight
    weapon? ? weapon_config.weight : 0
  end

  def pylon_weight
    pylon? ? pylon_config.weight : 0
  end

  def amount
    @config.amount || 1
  end

  def weapon?
    weapon_id.present?
  end

  def pylon?
    pylon_id.present?
  end

  def payload_id
    weapon_id || pylon_id
  end

  def weapon_id
    @config.weapon
  end

  def pylon_id
    @config.pylon
  end

  def weapon_config
    Settings.payload[weapon_id]
  end

  def pylon_config
    Settings.payload[pylon_id]
  end
end
