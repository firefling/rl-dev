class Array
  def longest
    sort_by{ |e| e.to_s.length }.last
  end
end
