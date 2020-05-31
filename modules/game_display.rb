module GameDisplay
  def clear_screen
    system "clear"
    system "cls"
  end

  def puts_display
    clear_screen
    puts '-' * GAME_WIDTH, "r_chess".center(GAME_WIDTH), '-' * GAME_WIDTH
    board.draw
    puts "\e[1;4m#{player.to_s.upcase} turn:\e[0m "
    unless board.captured_pieces[player].empty?
      puts "Captured pieces: #{board.captured_pieces_string(player)}"
    end
    puts "Your king is in check!" if king_in_check?
  end

  def puts_result_display
    color = player == :white ? :black : :white
    result = checkmate ? "#{color.to_s.capitalize} wins" : "It's a draw"
    clear_screen
    puts '-' * GAME_WIDTH, "r_chess".center(GAME_WIDTH), '-' * GAME_WIDTH
    board.draw
    unless board.captured_pieces[player].empty?
      puts "Captured pieces: #{board.captured_pieces_string(color)}" 
    end
    puts '=' * GAME_WIDTH
    print "\e[1m", "!!! #{result} !!!".center(GAME_WIDTH), "\e[0m\n"
    puts '=' * GAME_WIDTH
    puts "Thank you for playing!".center(GAME_WIDTH)
  end
end