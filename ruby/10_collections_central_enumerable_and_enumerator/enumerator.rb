e1 = Enumerator.new do |y|
  puts "start enumerator block"
  (1..5).each { |e| y << e }
  puts "end enumerator block"
end

# puts e1.to_a

# puts e1.select { |e| e < 3 }

a = [1, 2, 3, 4, 5]
e2 = Enumerator.new do |y|
  total = 0
  until a.empty?
    total += a.pop
    y << total
  end
end

puts e2.take(2)

puts a

