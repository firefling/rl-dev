def err str
  $stderr.puts str or exit(-1)
end

YX = Struct.new(:y, :x) do
  def + yx
    return self.add([yx[0], yx[1]])
  end

  def add yx
    return YX.new(self.y + yx[0], self.x + yx[1])
  end

  # def add! yx
  #   self.y += yx[0]
  #   self.x += yx[1]
  #   return self
  # end

  def left n=1 ; YX.new(self.y, self.x - n) ; end
  def right n=1 ; YX.new(self.y, self.x + n) ; end
  def up n=1 ; YX.new(self.y - n, self.x) ; end
  def down n=1 ; YX.new(self.y + n, self.x) ; end

  def left! n=1 ; self.x -= n ; self ; end
  def right! n=1 ; self.x += n ; self ; end
  def up! n=1 ; self.y -= n ; self ; end
  def down! n=1 ; self.y += n ; self ; end
end

class Array
  def longest
    sort_by{ |e| e.to_s.length }.last
  end
end
