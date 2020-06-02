require_relative "board"
require_relative "../modules/game_display"
require_relative "../modules/save_load"

class Game
  include GameDisplay, SaveLoad
  attr_reader :board, :player, :checkmate

  def initialize(test = false)
    @board = Board.new(test)
    @player = :white
  end

  public

  def menu
    input = nil
    loop do
      display_menu
      input = get_input(:menu)
      break if ['new', 'load', 'exit'].include?(input)
    end
    case input
    when 'new'
      play
    when 'load'
      load
    when 'exit'
      return
    end
  end

  private

  def play
    loop do 
      play_turn
      switch_player
      break if game_over?
    end
    display_result
  end

  def switch_player
    @player = player == :white ? :black : :white
  end

  def play_turn
    initial, final, piece = [nil, nil, nil]
    loop do
      display_turn
      initial, piece = get_initial_move
      board.highlight_moves(piece, initial)
      display_turn
      final = string_to_coordinates(get_input(:final, /^[a-h]\d$/))
      board.reset_highlights
      break unless invalid_move?(initial, final, piece) || king_in_check?(piece, initial, final)
    end
    board.move(initial, final, piece)
    reset_en_passant(player, board.board)
  end
  
  def get_initial_move
    initial = nil; piece = nil
    loop do
      string = get_input(:initial, /^[a-h]\d$/)
      save(save_data) if string == 'save'
      exit if string == 'exit'
      initial = string_to_coordinates(string)
      piece = board.get_chess_piece(initial)
      break unless piece.nil? || invalid_color?(piece)
    end
    [initial, piece]
  end

  def get_input(type, match = /\w+/)
    keywords = ['save', 'exit']
    string = nil
    loop do
      case type
      when :initial
        print "Get piece: "
      when :final
        print "Move to: "
      else
        print "Input: "
      end
      string = gets.chomp.downcase
      break if string.match?(match) || keywords.include?(string)
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

  def king_in_check?(piece = nil, piece_pos = nil, final = nil)
    king, pos = get_king_and_pos
    if piece
      board.board[piece_pos[1]][piece_pos[0]].piece = nil
      piece2 = board.board[final[1]][final[0]].piece
      board.board[final[1]][final[0]].piece = piece
    end
    check = king.check?(board.board, pos, true)
    if piece
      board.board[piece_pos[1]][piece_pos[0]].piece = piece
      board.board[final[1]][final[0]].piece = piece2
    end
    check
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
          if ch_moves.include?(mv)
            return false unless king_in_check?(piece, [x, y], mv)
          end
        end
      end
    end
    @checkmate = true
    true
  end

  def reset_en_passant(player, board)
    pawn_tiles = board.flatten.select do |tile| 
      piece = tile.piece
      piece.instance_of?(Pawn) && piece.en_passant && piece.color == player
    end
    pawn_tiles.each { |tile| tile.piece.en_passant = false }
  end

  def save_data
    data_hash = {
      board: @board,
      player: @player
    }
    YAML.dump(data_hash)
  end
end