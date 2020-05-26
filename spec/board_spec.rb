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
      expect(STDOUT).to receive(:puts).exactly(8).times
      expect(board).to receive(:print).exactly(64).times
      board.draw
    end
  end
end