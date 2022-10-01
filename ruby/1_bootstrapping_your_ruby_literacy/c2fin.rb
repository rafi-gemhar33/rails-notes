puts "Reading Celsius temperature value from data file.."

celcius = File.read("temp.dat")

farenheit = (celcius.to_i * 9 / 5) + 32

puts "The result is "
puts farenheit
puts "."