require_relative "board"

class Game
  attr_reader :board, :player

  def initialize(test = false)
    @board = Board.new(test)
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
    puts "Captured pieces: #{board.captured_pieces_string(player)}"
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
    board.move(initial, final, piece)
    reset_en_passant(player, board.board)
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
    king, pos = get_king_and_pos
    king.check?(board.board, pos, true)
  end

  def get_king_and_pos
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
    [king, pos]
  end

  def game_over?
    king, pos = get_king_and_pos
    checkmate?(king, pos) || stalemate?
  end

  def stalemate?
    board.board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        piece = tile.piece
        next if piece.nil? || piece.color != player
        return false unless piece.possible_moves([x, y], board.board).empty?
      end
    end
    true
  end

  def checkmate?(king, pos)
    return false unless king.check?(board.board, pos, true) && 
                        king.possible_moves(pos, board.board).empty?
    ch_piece = king.checking_piece[:piece]
    ch_pos = king.checking_piece[:pos]
    ch_moves = ch_piece.possible_moves(ch_pos, board.board)
    board.board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        piece = tile.piece
        next if piece.nil? || piece.color != king.color || piece.instance_of?(King)
        piece.possible_moves([x, y], board.board).each do |mv|
          return false if ch_moves.include?(mv)
        end
      end
    end
    true
  end

  def reset_en_passant(player, board)
    pawn_tiles = board.flatten.select do |tile| 
      piece = tile.piece
      piece.instance_of?(Pawn) && piece.en_passant && piece.color == player
    end
    pawn_tiles.each { |tile| tile.piece.en_passant = false }
  end
end