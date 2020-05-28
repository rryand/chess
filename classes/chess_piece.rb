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
        @moveset = MOVESET[:ROOK] + MOVESET[:BISHOP]
      else
        @moveset = MOVESET[key]
      end
      super(color)
    end

    define_method(:possible_moves) do |initial, board|
      special_pieces = [:BISHOP, :ROOK, :QUEEN]
      possible_moves = []
      #x, y = initial
      ms = @moveset
      ms = ms[1..-1] unless moves.empty? && key == :PAWN
      ms.each do |move|
        x,y = initial
        x += move[0]
        y += move[1]
        loop do
          break unless [x, y].all? { |i| i.between?(0, 7) }
          piece = board[y][x].piece
          break if key == :PAWN && ms[-2..-1].include?(move) && (piece.nil? || piece.color == color)
          possible_moves << [x, y] if piece.nil? || (piece.color != color && key != :PAWN)
          #p [x, y]
          break if piece || !special_pieces.include?(key)
          x += move[0]
          y += move[1]
        end
      end
      possible_moves
    end
  end
  Object.const_set(klass_name, klass)
end 