WHITE = {
  ROOK: " \u265C ",
  KNIGHT: " \u265E ",
  BISHOP: " \u265D ",
  QUEEN: " \u265B ",
  KING: " \u265A ",
  PAWN: " \u265F "
}

BLACK = {
  ROOK: " \u2656 ",
  KNIGHT: " \u2658 ",
  BISHOP: " \u2657 ",
  QUEEN: " \u2655 ",
  KING: " \u2654 ",
  PAWN: " \u2659 "
}

MOVESET = {
  ROOK: [
    [0, 1], [0, -1], [1, 0], [-1, 0]
  ],
  KNIGHT: [
    [1, 2], [2, 1], [-1, 2], [-2, 1],
    [1, -2], [2, -1], [-1, -2], [-2, -1]
  ],
  BISHOP: [
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ],
  WHITE_PAWN: [
    [0, 2], [0, 1], [1, 1], [-1, 1]
  ],
  BLACK_PAWN: [
    [0, -2], [0, -1], [1, -1], [-1, -1]
  ]
}

class ChessPiece
  attr_reader :color
  attr_accessor :alive, :moves

  def initialize(color)
    @color = color
    @alive = true
    @moves = []
  end

  public

  def move(pos_string, board) #as long as move is valid
    letters = ('a'..'h').to_a
    initial, final = pos_string.downcase.split(':')
    return nil unless valid_move?(initial, final, letters)
    moves << pos_string
    piece = get_chess_piece(initial, board, letters)
    set_chess_piece(final, piece, board, letters)
  end

  private
  
  #refactor x_init, y_init, x_fin, y_fin
  def get_chess_piece(initial, board, letters)
    x_init = letters.index(initial[0])
    y_init = (initial[1].to_i - 8).abs
    piece = board[x_init][y_init].piece
    board[y_init][x_init].piece = nil
    piece
  end

  def set_chess_piece(final, piece, board, letters)
    x_fin = letters.index(final[0])
    y_fin = (final[1].to_i - 8).abs
    board[y_fin][x_fin].piece = piece
  end

  def valid_move?(initial, final, letters)
    x_init = letters.index(initial[0])
    y_init = (initial[1].to_i - 8).abs
    x_fin = letters.index(final[0])
    y_fin = (final[1].to_i - 8).abs
    mv = [x_fin - x_init, y_init - y_fin]
    if self.class.to_s == "Pawn" && moves.empty?
      return false unless moveset[1..-1].include?(mv)
    else
      return false unless moveset.include?(mv)
    end
    true
  end
end

WHITE.each_key do |key|
  klass_name = key.to_s.downcase.capitalize
  klass = Class.new(ChessPiece) do
    attr_reader :char, :moveset

    define_method(:initialize) do |color|
      @char = color == :white ? WHITE[key] : BLACK[key]
      case key
      when :PAWN
        @moveset = color == :white ? MOVESET[:WHITE_PAWN] : MOVESET[:BLACK_PAWN]
      when :QUEEN
        @moveset = MOVESET[:ROOK] + MOVESET[:BISHOP]
      when :KING
        @moveset = MOVESET[:ROOK]
      else
        @moveset = MOVESET[key]
      end
      super(color)
    end
  end
  Object.const_set(klass_name, klass)
end 