require_relative "../classes/chess_piece"
require_relative "../classes/board"

describe Pawn do
  let(:board) { board = Board.new }

  context "white pieces" do
    it "creates a pawn piece" do
      pawn = Pawn.new(:white)
      expect(pawn.color).to eq(:white)
      expect(pawn.char).to eq(WHITE[:PAWN])
    end
    
    it "creates a rook piece" do
      rook = Rook.new(:white)
      expect(rook.color).to eq(:white)
      expect(rook.char).to eq(WHITE[:ROOK])
    end
  end

  context "black pieces" do
    it "creates a pawn piece" do
      pawn = Pawn.new(:black)
      expect(pawn.color).to eq(:black)
      expect(pawn.char).to eq(BLACK[:PAWN])
    end
    
    it "creates a rook piece" do
      rook = Rook.new(:black)
      expect(rook.color).to eq(:black)
      expect(rook.char).to eq(BLACK[:ROOK])
    end
  end
end