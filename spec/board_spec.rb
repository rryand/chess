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
    it "returns nil if there is no chess piece" do
      expect(board.move("a3:a6")).to be_nil
    end

    context "white pieces:" do
      color = :white

      it "moves pawn 1 square forward" do
        board.move("a2:a3", color)
        expect(board.board[5][0].piece).to_not be_nil
      end

      it "returns nil if invalid move" do
        expect(board.move("a2:a5", color)).to be_nil
      end

      it "returns nil if pawn attempts to move diagonally" do
        expect(board.move("a2:b3", color)).to be_nil
      end

      it "returns nil if capturing friendly unit" do
        board.move("b2:b3")
        expect(board.move("a2:b3", color)).to be_nil
      end

      it "moves bishop diagonally" do
        board.move("d2:d4")
        board.move("d7:d5")
        expect(board.move("c1:f4", color)).to_not be_nil
      end

      it "returns nil if bishop has , colorinvalid move" do
        board.move("d2:d4")
        board.move("d7:d5")
        expect(board.move("c1:f5", color)).to be_nil
      end

      it "returns nil if special piece collision is detected" do
        board.move("d2:d4")
        board.move("d7:d5")
        board.move("c1:f4")
        board.move("e7:e5")
        expect(board.move("f4:d6", color)).to be_nil
      end

      it "returns nil if pawn collision is detected" do
        board.move("c2:c4")
        board.move("c7:c5")
        board.draw
        expect(board.move("c4:c5", color)).to be_nil
      end
    end

    context "black pieces:" do
      color = :black
      
      it "moves pawn 1 square forward" do
        board.move("c7:c6", color)
        expect(board.board[2][2].piece).to_not be_nil
      end

      it "returns nil if invalid move" do
        expect(board.move("c7:c4", color)).to be_nil
      end

      it "returns nil if pawn moves diagonally" do
        expect(board.move("c7:b6", color)).to be_nil
      end

      it "returns nil if bishop has invalid move" do
        board.move("d2:d4")
        board.move("d7:d5")
        board.move("c2:c3")
        expect(board.move("c8:f6", color)).to be_nil
      end

      it "moves bishop diagonally" do
        board.move("d2:d4")
        board.move("d7:d5")
        board.move("c2:c3")
        expect(board.move("c8:f5", color)).to_not be_nil
      end
    end
  end
end