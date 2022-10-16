def fb_calc(i)
  case 0
  when i % 15
    "FizzBuzz"
  when i % 3
    "Fizz"
  when i % 5
    "Buzz"
  else i.to_s
  end
end

def fb(n)
  (1..n).map {|i| fb_calc(i) }
end