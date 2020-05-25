require_relative "../classes/board"

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

describe Board do
  let(:board) { Board.new }

  it "builds a board once initialized" do
    expect(board.board.size).to eq(8)
    expect(board.board[0].size).to eq(8)
  end

  describe "#draw" do
    it "draws the board to the terminal" do
      expect(STDOUT).to receive(:puts).exactly(8).times
      expect(board).to receive(:print).exactly(64).times
      board.draw
    end
  end

  describe "#position_chess_pieces" do
    it "places chess pieces on the board" do
      puts
      board_arr = board.instance_variable_get(:@board)

      black_values = BLACK.values[0...-1] # exclude pawn
      black_values.push(BLACK[:BISHOP], BLACK[:KNIGHT], BLACK[:ROOK])
      board_arr[0].each_with_index do |element, index| 
        board_arr[0][index] = element.split.insert(1, black_values[index]).join
      end
      board_arr[1].map! { |element| element.split.insert(1, BLACK[:PAWN]).join }

      white_values = WHITE.values[0...-1] # exclude pawn
      white_values.push(WHITE[:BISHOP], WHITE[:KNIGHT], WHITE[:ROOK])
      board_arr[7].each_with_index do |element, index| 
        board_arr[7][index] = element.split.insert(1, white_values[index]).join
      end
      board_arr[6].map! { |element| element.split.insert(1, WHITE[:PAWN]).join }

      board.draw
      expect(Board.new.board).to eq(board_arr)
      Board.new.draw
    end
  end
end