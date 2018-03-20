def err str
  $stderr.puts str or exit(-1)
end

Coordinates = Struct.new(:y, :x) do
  def + coordinates
    self.offset(coordinates)
  end

  def - coordinates
    Coordinates.new(self.y - coordinates.y, self.x - coordinates.x)
  end

  def offset coordinates
    Coordinates.new(self.y + coordinates.y, self.x + coordinates.x)
  end

  def left n=1 ; Coordinates.new(self.y, self.x - n) ; end
  def right n=1 ; Coordinates.new(self.y, self.x + n) ; end
  def up n=1 ; Coordinates.new(self.y - n, self.x) ; end
  def down n=1 ; Coordinates.new(self.y + n, self.x) ; end

  def left! n=1 ; self.x -= n ; end
  def right! n=1 ; self.x += n ; end
  def up! n=1 ; self.y -= n ; end
  def down! n=1 ; self.y += n ; end
end

class Array
  def longest
    sort_by{ |e| e.to_s.length }.last
  end
end
