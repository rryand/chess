class Tile
  attr_reader :bg_color
  attr_accessor :piece, :highlight

  def initialize(bg_color, piece = nil)
    @bg_color = bg_color
    @piece = piece
    @highlight = nil
  end

  def string
    bg = highlight.nil? ? bg_color : highlight
    if piece.nil?
      bg
    else
      bg.split.insert(1, piece.char).join
    end
  end
end