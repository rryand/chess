class Tile
  attr_reader :bg_color
  attr_accessor :piece

  def initialize(bg_color, piece = nil)
    @bg_color = bg_color
    @piece = piece
  end

  def string
    if piece.nil?
      bg_color
    else
      bg_color.split.insert(1, piece).join
    end
  end
end