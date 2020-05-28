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
      #p initial, final, piece
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
    #p piece.possible_moves(initial, board.board)
    piece.nil? || invalid_color?(piece) || 
    !piece.possible_moves(initial, board.board).include?(final)
  end

  def invalid_color?(piece)
    piece.color != player
  end

  def game_over?
    false
  end
end