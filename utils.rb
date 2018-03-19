def err str
  $stderr.puts str or exit(-1)
end

Coordinates = Struct.new(:y, :x)

class Array
  def longest
    sort_by{ |e| e.to_s.length }.last
  end
end
