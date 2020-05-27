require_relative "../classes/board"

describe Board do
  let(:board) { Board.new }

  context "once initialized" do
    it "builds a board" do
      expect(board.board.size).to eq(8)
      expect(board.board[0].size).to eq(8)
    end

    it "places chess pieces on the board" do
      [0, 1, 6, 7].each do |index|
        board.board[index].each do |tile|
          expect(tile.piece).to_not be_nil
        end
      end
    end
  end

  describe "#draw" do
    it "draws the board to the terminal" do
      expect(STDOUT).to receive(:puts).at_least(8).times
      expect(board).to receive(:print).at_least(64).times
      board.draw
    end
  end

  describe "#move" do
    it "moves pawn 1 square forward" do
      board.move("a2:a3")
      board.draw
      expect(board.board[5][0].piece).to_not be_nil
    end

    it "returns nil if invalid move" do
      expect(board.move("a2:a5")).to be_nil
    end

    it "returns nil if there is no chess piece" do
      expect(board.move("a3:a6")).to be_nil
    end
  end
end