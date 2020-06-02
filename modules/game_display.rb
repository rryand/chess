module GameDisplay
  GAME_WIDTH = 50

  public
  
  def clear_screen
    system "clear"
    system "cls"
  end

  def display_menu
    clear_screen
    puts header
    puts welcome_text
  end

  def display_turn
    clear_screen
    puts header
    board.draw
    puts "\e[1;4m#{player.to_s.upcase} turn:\e[0m "
    unless board.captured_pieces[player].empty?
      puts "Captured pieces: #{board.captured_pieces_string(player)}"
    end
    puts "Your king is in check!" if king_in_check?
  end

  def display_result
    color = player == :white ? :black : :white
    result = checkmate ? "#{color.to_s.capitalize} wins" : "It's a draw"
    clear_screen
    puts header
    board.draw
    unless board.captured_pieces[player].empty?
      puts "Captured pieces: #{board.captured_pieces_string(color)}" 
    end
    puts '=' * GAME_WIDTH
    print "\e[1m", "!!! #{result} !!!".center(GAME_WIDTH), "\e[0m\n"
    puts '=' * GAME_WIDTH
    puts "Thank you for playing!".center(GAME_WIDTH)
  end

  private

  def header
    title = "rchess"

    <<~GAMETEXT
    #{'-' * GAME_WIDTH}\e[1m
    #{title.center(GAME_WIDTH)}
    \e[0m#{'-' * GAME_WIDTH}
    GAMETEXT
  end

  def welcome_text
    url = "https://www.chess.com/learn-how-to-play-chess"

    <<~GAMETEXT

    Welcome to rchess! Here, you engage in a battle of
    wits and strategy to determine who is the chess
    grandmaster.

    For the rules of chess, please visit
    \e[2m#{url}\e[0m

    This game was made using the Ruby programming 
    language.

    Options:
      'new'   -   Play a new game
      'load'  -   Load a saved game
      'exit'  -   Exit rchess 

    GAMETEXT
  end
end