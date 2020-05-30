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
      play_turn
      switch_player
    end
  end

  private

  def clear_screen
    print `clear`
  end

  def puts_display
    clear_screen
    puts '-' * 40, "r_chess".center(40), '-' * 40
    board.draw
    puts "\e[1;4m#{player.to_s.upcase} turn:\e[0m "
  end

  def switch_player
    @player = player == :white ? :black : :white
  end

  def play_turn
    initial, final, piece = [nil, nil, nil]
    loop do
      puts_display
      initial, piece = get_initial_move
      board.highlight_moves(piece, initial)
      puts_display
      final = string_to_coordinates(get_input(:final))
      board.reset_highlights
      break unless invalid_move?(initial, final, piece) || king_in_check?
    end
    piece.moves << final
    board.move(initial, final, piece)
  end
  
  def get_initial_move
    initial = nil; piece = nil
    loop do
      initial = string_to_coordinates(get_input(:initial))
      piece = board.get_chess_piece(initial)
      break unless piece.nil? || invalid_color?(piece)
    end
    [initial, piece]
  end

  def get_input(type)
    string = nil
    loop do
      print type == :initial ? "Get piece " : "Move to "
      print "(e.g. a2): "
      string = gets.chomp.downcase
      break if string.match?(/^[a-h]\d$/)
    end
    string
  end

  def string_to_coordinates(string)
    letters = ('a'..'h').to_a
    arr = string.chars
    [letters.index(arr[0]), arr[1].to_i - 1]
  end

  def invalid_move?(initial, final, piece)
    !piece.possible_moves(initial, board.board).include?(final)
  end

  def invalid_color?(piece)
    piece.color != player
  end

  def king_in_check?
    king = nil; pos = nil
    board.board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        if tile.piece.instance_of?(King) && tile.piece.color == player
          king = tile.piece
          pos = [x, y]
          break
        end
      end
    end
    king.check?(board.board, pos, true)
  end

  def game_over?
    false
  end
end