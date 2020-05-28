require_relative "board"

class Game
  attr_reader :board, :player

  def initialize
    @board = Board.new
    @player = :white
  end

  public

  def play
    until game_over?
      #clear_screen
      puts '-' * 40, "r_chess".center(40), '-' * 40
      play_turn
      switch_player
    end
  end

  private

  def clear_screen
    print `clear`
  end

  def switch_player
    @player = player == :white ? :black : :white
  end

  def play_turn
    initial, final, piece = [nil, nil, nil]
    board.draw
    puts "\e[1;4m#{player.to_s.upcase} turn:\e[0m "
    loop do
      initial, final = string_to_coordinates(get_input)
      piece = board.get_chess_piece(initial)
      p initial, final, piece
      break unless invalid_move?(initial, final, piece)
    end
    puts "moving!"
    board.move(initial, final, piece)
  end

  def get_input
    string = nil
    loop do
      print "Play move (e.g. a2:a4): "
      string = gets.chomp.downcase
      break if string.match?(/^[a-h]\d:[a-h]\d$/)
    end
    string
  end

  def string_to_coordinates(string)
    letters = ('a'..'h').to_a
    initial, final = string.split(':')
    initial = [letters.index(initial[0]), initial[1].to_i - 1]
    final = [letters.index(final[0]), final[1].to_i - 1]
    [initial, final]
  end

  def invalid_move?(initial, final, piece)
    x_init, y_init = initial
    x_fin, y_fin = final
    mv = return_move(x_init, y_init, x_fin, y_fin, piece)
    piece.nil? || !within_board?(initial, final) || 
    outside_moveset?(x_fin, y_fin, mv, piece)
  end

  def return_move(x_init, y_init, x_fin, y_fin, piece)
    special_pieces = ["Rook", "Bishop", "Queen"]
    mv = [x_fin - x_init, y_fin - y_init]
    min = mv.max < mv.min.abs ? mv.max : mv.min.abs
    if special_pieces.include?(piece.class.to_s)
      return mv.map { |i| i >= 0 ? (i - min + 1) : (i.abs - min + 1) * -1 }
    end
    mv
  end

  def within_board?(initial, final)
    [initial, final].all? { |arr| arr.all? { |pos| pos.between?(0, 7) } }
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

  def game_over?
    false
  end
end