require_relative "tile"
require_relative "chess_piece"
require_relative "../modules/collision_check"

BG_BLACK = "\e[40m   \e[0m"
BG_WHITE = "\e[47m   \e[0m"

class Board
  #include CollisionCheck
  attr_accessor :board

  def initialize
    build
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

=begin
  def move(pos_string, player) #as long as move is valid
    pos_string = pos_string.downcase
    return nil unless pos_string.match?(/^[a-h]\d:[a-h]\d$/)
    letters = ('a'..'h').to_a
    initial, final = pos_string.split(':')
    initial = [letters.index(initial[0]), (initial[1].to_i - 8).abs]
    final = [letters.index(final[0]), (final[1].to_i - 8).abs]
    piece = get_chess_piece(initial)
    return nil if piece.nil? || invalid_color?(piece, player) || invalid_move?(initial, final, piece)
    remove_chess_piece(initial)
    piece.moves << pos_string
    set_chess_piece(final, piece)
  end
=end

  private

  def build
    @board = build_board
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

=begin
  def invalid_move?(initial, final, piece)
    x_init, y_init = initial
    x_fin, y_fin = final
    return true unless [x_init, y_init, x_fin, y_fin].all? { |pos| pos.between?(0, 8) }
    mv = return_move(x_init, y_init, x_fin, y_fin, piece)
    outside_moveset?(x_fin, y_fin, mv, piece) || 
    friendly_fire?(piece, board[y_fin][x_fin].piece) ||
    collision(initial, final, mv, piece)
  end
=end
end