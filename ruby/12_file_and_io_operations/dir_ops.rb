require 'pry'
newdir = "/Users/rafi/Desktop/rails-notes/ruby/12_file_and_io_operations/newdir"
Dir.mkdir(newdir)

print "Is #{newdir} empty? "
puts Dir.empty?(newdir)

newfile = "newfile"

binding.pry
Dir.chdir(newdir) do
  File.open(newfile, "w") do |f|
    f.puts "Sample file in new directory"
  end
  puts "Current directory: #{Dir.pwd}"
  puts "Directory listing: "
  p Dir.entries(".")
  File.unlink(newfile)
end

# Dir.rmdir(newdir)
print "Does #{newdir} still exist? "
if File.exist?(newdir)
  puts "Yes"
else
puts "No" 
end