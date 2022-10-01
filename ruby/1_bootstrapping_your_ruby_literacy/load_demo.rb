puts "This is the first (master) program file."
load "loadme.rb"
puts  "************"
print $LOAD_PATH , "\n"
puts  "************"
puts  "###############"
puts $:
puts  "###############"
puts "And back again to the first file."