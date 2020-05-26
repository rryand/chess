require_relative "../classes/chess_piece"

describe Pawn do
  it "creates a white pawn piece" do
    pawn = Pawn.new(:white)
    expect(pawn.color).to eq(:white)
    expect(pawn.char).to eq(WHITE[:PAWN])
    p pawn
  end
  
  it "creates a white rook piece" do
    rook = Rook.new(:white)
    expect(rook.color).to eq(:white)
    p rook
  end
end