BG_BLACK = "\e[40m   \e[0m"
BG_WHITE = "\e[47m   \e[0m"

class Board
  attr_reader :board

  def initialize
    @board = build
  end

  def build
    Array.new(8) do |index1| 
      Array.new(8) do |index2|
        if index1 % 2 == 0 #even
          index2 % 2 == 0 ? BG_WHITE : BG_BLACK
        else
          index2 % 2 == 0 ? BG_BLACK : BG_WHITE
        end
      end
    end
  end

  def draw
    board.each do |arr|
      arr.each { |element| print element }
      puts
    end
  end
end