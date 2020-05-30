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

# REFACTOR CODE or make separate class pages for each chess piece
WHITE.each_key do |key|
  klass_name = key.to_s.downcase.capitalize
  klass = Class.new(ChessPiece) do
    attr_reader :char, :moveset
    attr_accessor :en_passant if key == :PAWN

    define_method(:initialize) do |color|
      @char = color == :white ? WHITE[key] : BLACK[key]
      case key
      when :PAWN
        @moveset = color == :white ? MOVESET[:WHITE_PAWN] : MOVESET[:BLACK_PAWN]
        @en_passant = false
      when :QUEEN
        @moveset = MOVESET[:ROOK] + MOVESET[:BISHOP]
      when :KING
        @moveset = MOVESET[:ROOK] + MOVESET[:BISHOP]
      else
        @moveset = MOVESET[key]
      end
      super(color)
    end

    public

    define_method(:possible_moves) do |initial, board|
      special_pieces = [:BISHOP, :ROOK, :QUEEN]
      possible_moves = []
      ms = @moveset
      ms = ms[1..-1] if key == :PAWN && !moves.empty? 
      ms.each do |move|
        x, y = initial
        x += move[0]
        y += move[1]
        loop do
          break unless x.between?(0, 7) && y.between?(0, 7) #outside board
          piece = board[y][x].piece
          break if key == :PAWN && (invalid_move?(move, ms, piece) || 
                   double_move_block?(move, board, initial))
          break if key == :KING && check?(board, [x, y]) #king can't move into zone of attack
          possible_moves << [x, y] if piece.nil? || piece.color != color
          break if piece || !special_pieces.include?(key)
          x += move[0]
          y += move[1]
        end
      end
      add_en_passant(initial, board, possible_moves) if key == :PAWN
      possible_moves
    end

    if key == :KING
      #same_spot = true if used in Game#king_in_check?
      define_method(:check?) do |board, pos, same_spot = false|
        board.each_with_index do |row, y|
          row.each_with_index do |tile, x|
            piece = tile.piece
            next if piece.nil? || piece.color == color || (piece.instance_of?(King) && same_spot)
            if piece.instance_of? Pawn
              return true if piece.possible_moves([x, y], board).any? do |move|
                move[0] != x && move == pos
              end
            else
              return true if piece.possible_moves([x, y], board).include? pos
            end
          end
        end
        false
      end
    end

    private

    if key == :PAWN
      define_method(:invalid_move?) do |move, ms, piece|
        (ms[-2..-1].include?(move) && (piece.nil? || piece.color == color)) ||
        (!ms[-2..-1].include?(move) && piece)
      end

      define_method(:double_move_block?) do |move, board, initial|
        x, y = initial
        move == moveset[0] && !board[y + moveset[1][1]][x].piece.nil?
      end

      define_method(:add_en_passant) do |initial, board, possible_moves|
        x, y = initial
        return unless y == 3 || y == 4
        y_pos = y + moveset[1][1]
        [x - 1, x + 1].each do |x_pos|
          next unless x_pos.between?(0, 7)
          piece = board[y][x_pos].piece
          unless piece.nil? || piece.color == color || piece.moves.size != 1
            @en_passant = true
            possible_moves << [x_pos, y_pos] 
          end
        end
      end
    end
  end
  Object.const_set(klass_name, klass)
end 