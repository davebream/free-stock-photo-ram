class Color
  def initialize(red, green, blue)
    @red = red
    @green = green
    @blue = blue
  end

  def self.from_hex(hex)
    new(*hex[1..].scan(/../).map(&:hex))
  end

  def rgb
    [@red, @green, @blue]
  end

  def hex
    "##{rgb.map { |c| c.to_s(16) }.join}".upcase
  end
end
