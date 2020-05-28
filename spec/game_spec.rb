require_relative "../classes/game"

describe Game do
  let(:game) { Game.new }

  it "creates a board once initialized" do
    board = game.board
    expect(board).to be_an_instance_of(Board)
    expect(board.board.size).to eq(8)
  end
end