module CollisionCheck
  def collision(initial, final, move, piece)
    klass = piece.class.to_s
    if ["Rook", "Bishop", "Queen"].include?(klass)
      collision_special(initial, final, move)
    elsif klass != "Knight" #add for pawn
      return true unless board[final[1]][final[0]].piece.nil?
    end
    false #knight default
  end

  def collision_special(initial, final, move)
    arr = [initial]
    x1, y1 = move
    until arr[-1] == final
      x2, y2 = arr[-1]
      arr << [x2 + x1, y2 - y1]
      return true unless board[y2 - y1][x2 + x1].nil?
    end
  end
end