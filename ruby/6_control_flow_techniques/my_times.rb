class Integer
  def my_times
    c = 0
    puts "c = 0"
    puts "until c == #{self}..."

    until c == self
      yield c
      c += 1
    end
    self
  end
end