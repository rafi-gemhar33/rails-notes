
puts "Hello please enter a calcius value: "
celcius = gets
farenheit = (celcius.to_i * 9 / 5) + 32

puts "Saving result to output file 'temp.out'"
fh = File.new('temp.out', 'w')
fh.puts "The result is #{farenheit}"
fh.close