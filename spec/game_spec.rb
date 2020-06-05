require_relative "../classes/game"

describe Game do
  let(:game) { Game.new(true) }
  before(:each) do
    @board = game.board
  end

  it "creates a board once initialized" do
    expect(@board).to be_an_instance_of(Board)
    expect(@board.board.size).to eq(8)
  end

  describe "#checkmate?" do
    let(:king) { King.new(:black) }
    it "returns true if checkmate" do
      @board.board[4][7].piece = king
      @board.board[0][7].piece = Rook.new(:white)
      @board.board[1][6].piece = Rook.new(:white)
      king.check?(@board.board, [7, 4], true)
      expect(game.send(:checkmate?, king, [7, 4])).to be_truthy
    end

    it "returns false if check but not checkmate" do
      @board.board[4][7].piece = king
      @board.board[0][7].piece = Rook.new(:white)
      king.check?(@board.board, [7, 4], true)
      expect(game.send(:checkmate?, king, [7, 4])).to be_falsy
    end
  end

  describe "#promote_pawn" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(game).to receive(:print)
      allow(game).to receive(:gets).and_return('1\n')
    end

    it "promotes a white pawn" do
      pawn = Pawn.new(:white)
      @board.board[7][4].piece = pawn
      game.send(:promote_pawn, pawn, [4, 7])
      expect(@board.board[7][4].piece).to be_an_instance_of(Queen)
    end

    it "promotes a black pawn" do
      pawn = Pawn.new(:black)
      @board.board[0][4].piece = pawn
      game.send(:switch_player)
      game.send(:promote_pawn, pawn, [4, 0])
      expect(@board.board[0][4].piece).to be_an_instance_of(Queen)
    end
  end
end