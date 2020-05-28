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
      clear_screen
      puts '-' * 40, "r_chess".center(40), '-' * 40
      play_turn
      switch_player
    end
  end

  private

  def clear_screen
    print `clear`
  end

  def play_turn
    board.draw
    puts "\e[1;4m#{player.to_s.upcase} turn:\e[0m "
    move = nil
    move = board.move(get_input, player) while move.nil?
  end

  def switch_player
    @player = player == :white ? :black : :white
  end

  def get_input
    print "Play move (e.g. a2:a4): "
    gets.chomp
  end

  def game_over?
    false
  end
end