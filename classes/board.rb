require_relative "tile"
require_relative "chess_piece"

BG_BLACK = "\e[40m   \e[0m"
BG_WHITE = "\e[47m   \e[0m"

class Board
  attr_accessor :board

  def initialize(test = false)
    build(test)
  end

  public

  def draw
    board.reverse.each_with_index do |arr, index|
      print "#{(index - 8).abs}|"
      arr.each { |tile| print tile.string }
      puts
    end
    ('a'..'h').each do |letter|
      print letter == 'a' ? "   #{letter} " : " #{letter} "
    end
    puts
  end

  def move(initial, final, piece)
    remove_chess_piece(initial)
    set_chess_piece(final, piece)
  end

  def get_chess_piece(initial)
    x_init, y_init = initial
    board[y_init][x_init].piece
  end

  private

  def build(test)
    @board = build_board
    return if test == true
    place_pieces(WHITE, 0, 1)
    place_pieces(BLACK, 7, 6)
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

  def remove_chess_piece(initial)
    x_init, y_init = initial
    board[y_init][x_init].piece = nil
  end

  def set_chess_piece(final, piece)
    x_fin, y_fin = final
    
    # add captured chess pieces to own instance variable

    board[y_fin][x_fin].piece = piece
  end
end