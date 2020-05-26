require_relative "tile"

BG_BLACK = "\e[40m   \e[0m"
BG_WHITE = "\e[47m   \e[0m"

class Board
  attr_reader :board

  def initialize
    build
  end

  public

  def draw
    board.each do |arr|
      arr.each { |tile| print tile.string }
      puts
    end
  end

  private

  def build
    @board = build_board
    place_pieces
  end

  def build_board
    Array.new(8) do |index1| 
      Array.new(8) do |index2|
        if index1 % 2 == 0 #even
          index2 % 2 == 0 ? Tile.new(BG_WHITE) : Tile.new(BG_BLACK)
        else
          index2 % 2 == 0 ? Tile.new(BG_BLACK) : Tile.new(BG_WHITE)
        end
      end
    end
  end

  def place_pieces
    place_black_pieces
    place_white_pieces
  end

=begin
  def place_black_pieces
    black_values = BLACK.values[0...-1] # exclude pawn
    black_values.push(BLACK[:BISHOP], BLACK[:KNIGHT], BLACK[:ROOK])
    @board[0].each_with_index do |tile, index|
      tile.piece = black_values[index]
    end
    @board[1].each { |tile| tile.piece = BLACK[:PAWN] }
  end

  def place_white_pieces
    white_values = WHITE.values[0...-1] # exclude pawn
    white_values.push(WHITE[:BISHOP], WHITE[:KNIGHT], WHITE[:ROOK])
    @board[-1].each_with_index do |tile, index|
      tile.piece = white_values[index]
    end
    @board[-2].each { |tile| tile.piece = WHITE[:PAWN] }
  end
=end
end