require_relative "tile"
require_relative "chess_piece"

BG_BLACK = "\e[40m   \e[0m"
BG_WHITE = "\e[47m   \e[0m"

class Board
  attr_accessor :board

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
    place_pieces(BLACK, 0, 1)
    place_pieces(WHITE, 7, 6)
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

  def place_pieces(hash, index1, index2)
    color = hash == WHITE ? :white : :black
    keys = hash.keys[0...-1] # exclude pawn
    keys.push(:BISHOP, :KNIGHT, :ROOK)
    @board[index1].each_with_index do |tile, index|
      tile.piece = Object.const_get(keys[index].to_s.downcase.capitalize).new(color)
    end
    @board[index2].each { |tile| tile.piece = Pawn.new(color) }
  end
end