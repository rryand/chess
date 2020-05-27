module CollisionCheck

  public

  def collision(initial, final, move, piece)
    klass = piece.class.to_s
    if ["Rook", "Bishop", "Queen"].include?(klass)
      collision_special(initial, final, move)
    elsif klass == "Knight"
      collision_knight
    else
      collision_pawn(initial, move, piece)
    end
  end

  private

  def collision_special(initial, final, move)
    arr = [initial]
    x1, y1 = move
    until arr[-1] == final
      x2, y2 = arr[-1]
      arr << [x2 + x1, y2 - y1]
      return true unless board[y2 - y1][x2 + x1].nil?
    end
    false
  end

  def collision_knight
    false
  end

  def collision_pawn(initial, move, piece)
    x1, y1 = move
    x2, y2 = initial
    if piece.moveset[0] == move
      return true unless board[y2 - (y1.abs)/y1][x1].piece.nil? && board[y2 - y1][x1].piece.nil?
    elsif piece.moveset[1] == move
      return true unless board[y2 - y1][x1].piece.nil?
    end
    false
  end
end