require_relative "tile"
require_relative "chess_piece"
require_relative "../modules/collision_check"

BG_BLACK = "\e[40m   \e[0m"
BG_WHITE = "\e[47m   \e[0m"

class Board
  include CollisionCheck
  attr_accessor :board

  def initialize
    build
  end

  public

  def draw
    board.each_with_index do |arr, index|
      print "#{(index - 8).abs}|"
      arr.each { |tile| print tile.string }
      puts
    end
    ('a'..'h').each do |letter|
      print letter == 'a' ? "   #{letter} " : " #{letter} "
    end
    puts
  end

  def move(pos_string) #as long as move is valid
    letters = ('a'..'h').to_a
    initial, final = pos_string.downcase.split(':')
    initial = [letters.index(initial[0]), (initial[1].to_i - 8).abs]
    final = [letters.index(final[0]), (final[1].to_i - 8).abs]
    piece = get_chess_piece(initial)
    return nil if piece.nil? || invalid_move?(initial, final, piece)
    remove_chess_piece(initial)
    piece.moves << pos_string
    set_chess_piece(final, piece)
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

  def get_chess_piece(initial)
    x_init, y_init = initial
    board[y_init][x_init].piece
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

  def invalid_move?(initial, final, piece)
    x_init, y_init = initial
    x_fin, y_fin = final
    return true unless [x_init, y_init, x_fin, y_fin].all? { |pos| pos.between?(0, 8) }
    mv = return_move(x_init, y_init, x_fin, y_fin, piece)
    outside_moveset?(x_fin, y_fin, mv, piece) || 
    friendly_fire?(piece, board[y_fin][x_fin].piece) ||
    collision(initial, final, mv, piece)
  end

  def return_move(x_init, y_init, x_fin, y_fin, piece)
    special_pieces = ["Rook", "Bishop", "Queen"]
    mv = [x_fin - x_init, y_init - y_fin]
    min = mv.max < mv.min.abs ? mv.max : mv.min.abs
    if special_pieces.include?(piece.class.to_s)
      return mv.map { |i| i >= 0 ? (i - min + 1) : (i.abs - min + 1) * -1 }
    end
    mv
  end

  def outside_moveset?(x_fin, y_fin, move, piece)
    if piece.class.to_s == "Pawn"
      if piece.moveset[-2..-1].include?(move)
        return true if board[y_fin][x_fin].piece.nil?
      elsif !piece.moves.empty?
        return true unless piece.moveset[1..-1].include?(move)
      end
    end
    return true unless piece.moveset.include?(move)
    false
  end

  def friendly_fire?(piece, captured_piece)
    return false if captured_piece.nil?
    piece.color == captured_piece.color ? true : false
  end
end