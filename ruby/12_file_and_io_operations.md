
# 12 File and I/O operations

- even file and I/O operations object ori- ented
- `system` method that lets you execute a system command
- `FileUtils`, `Pathname`, and `StringIO` 

## 12.1 How Ruby’s I/O system is put together
-  `IO` class handles all input & output streams or via its descendant classes, like `File`
- wrapper around C standard library
  - methods like seek, getc, and eof?.
  
### The IO class 386 
-  instances represent readable and/or writable connections to disk files, keyboards, screens, and other devices.
- Ruby program starts up, it’s aware of the standard input, output, and error streams.
  - Encapulated via IO class
```rb
STDERR.class ### => IO
STDERR.puts("Problem!")
Problem! ### => nil
STDERR.write("Problem!\n")
Problem! ### => 9
```
`STDERR`, `STDIN`, and `STDOUT` are automatically set when the program starts
- IO objects has
  * puts automatic newline output
  * print no automatic newline output
  * write automatic newline output + returns bytes

### IO objects as enumerables 387

- iterate based on the global input record separator: global variable $/.(`each_line`)
- If we change `$/`'s value Ruby accepts keyboard input until it hits the string
- So $/ determines an IO object’s sense of "each."


### STDIN, STDOUT, STDERR 388 
- standard input, output, and error streams. 
- Ruby assumes that 
  - all input will come from the keyboard, 
  - all normal output will go to the terminal
- `puts` and `gets`, operate on `STDOUT` and `STDIN`,
-  to use STDERR for output, you have to name it explicitly:

#### THE STANDARD I/O GLOBAL VARIABLES
-  `$stdin`, `$stdout`, and `$stderr`.
- you’re not supposed to reassign to the constant, but you can reassign to the variable.


### A little more about keyboard input 389
- with gets and getc
```rb
line = gets
char = STDIN.getc
line = STDIN.gets
```

## 12.2 Basic file operations 390
- class File provides the facilities for manipulating files in Ruby.
 - File is a subclass of IO,
- 



### The basics of reading from files 390 

- Reading from a file can be performed 
  * one byte at a time
  * a specified number of bytes at a time, 
  * or one line at a time($/ delimiter)

- , it can be inefficient

```rb
f = File.new("ruby/7_built_in_essentials/tmp/display.rb")  #<File:code/ticket2.rb>
f.read
f.close
```
### Line-based file reading 391 

- read the next line from a file is with `gets`:
- `readline` method does much of what `gets` does
- EOL : `gets` returns `nil`, and `readline` raises a `fatal` error
- `readlines` gives an array of lines
-  `rewind` , which moves the File object’s internal position pointer back to the beginning of the file:
```rb
f.gets   ### => "class Ticket\n"
f.read   ### => "class Ticket\n..."
f.readline ### => EOFError (end of file reached)
f.readlines   ### => ["class Ticket\n", "  ...]
f.rewind  ### => 0
f.each {|line| puts "Next line: #{line}" }
```


### Byte- and character-based file reading 392

-  `getc` method reads and returns one character 
- "un-get" a character—that is, put a specific character back onto the file- input stream
- byte-wise as well as character-wise through a file, using `getbyte`.(encoding)
- `readchar` and `readbyte` differ from `getc` and `getbyte`, respectively, by raising error.
```rb
f.getc  ### => "c"
f.ungetc("X")  ### => nil
f.gets  ### => "Xlass Ticket\n"

f.getc   ### => nil
f.readchar ### EOFError (end of file reached)
f.getbyte ### => nil
f.readbyte  ## EOFError: (end of file reached)
```

### Seeking and querying file position 392 

- File object has a sense of where in the file it has left off reading.
- `pos`, tells where in the file the pointer is currently pointing:
- `seek` method moves the position pointer to a new location. 
  - useful for large files and to skip or ignore some contents
- offset
  - specific offset into the file, 
  - it can be relative to either the current pointer position or the end of the file.

```rb
f.pos   ###  => 0
f.gets   ###  => "class Ticket\n"
f.pos   ###  => 13
f.seek(20, IO::SEEK_SET)
f.seek(15, IO::SEEK_CUR)
f.seek(-10, IO::SEEK_END)
```

### Reading files with File class methods 393 

- `File.read` and `File.readlines`.
- does the same thing as instance-method counterparts do
- purely for convenience
```rb
full_text = File.read("myfile.txt")
lines_of_text = File.readlines("myfile.txt")
```

- low-level I/O operations.
  - These include `sysseek`, `sysread`, and `syswrite`.

### Writing to files 394 

- Writing to a file involves using `puts`, `print`, or `write` on a `File` object 
- Write mode is indicated by `w` as the second argument to new.
- In append mode (indicated by a)
  - opening it in append mode creates it, if does not exist
```rb
f = File.new("data.out", "w") ### => #<File:data.out>
f.puts "David A. Black, Rubyist" ### => nil
f.close ### => nil
puts File.read("data.out") ### David A. Black, Rubyist ### => nil
f = File.new("data.out", "a") ### => #<File:data.out>
f.puts "Joe Leo III, Rubyist" ### => nil
f.close ### => nil
puts File.read("data.out")
```

### Using blocks to scope file operations 395 

- alternate way to open files that 
  - puts the housekeeping task of closing the file in the hands of Ruby: **File.open with a code block.**

```rb
# records.txt:
# Pablo Casals|Catalan|cello|1876-1973
# Jascha Heifetz|Russian-American|violin|1901-1988
# Emanuel Feuermann|Austrian-American|cello|1902-1942
# read_records.rb:
File.open("records.txt") do |f|
  while record = f.gets
    name, nationality, instrument, dates = record.chomp.split('|')
    puts "#{name} (#{dates}), who was #{nationality}, played #{instrument}."
  end
end
```
### File enumerability 396

- you can replace the while idiom in the previous example with each:
```rb
File.new(somefile.txt) do |f|
  f.each do |lines|
    name, nationality, instrument, dates = lines.chomp.split('|')
    puts "my man is name"
  end
end
```
### File I/O exceptions and errors 397

- Errno namespace: 
- Errno::EACCES (permission denied), 
- Errno::ENOENT (no such entity—a file or directory), 
- Errno::EISDIR (is a directory—an error you get when you try to open a directory as if it were a file)

- Errno family of errors includes file-related errors + system errors;
- maps errors to integers 
  - Linux, “not a directory” error by the C macro `ENOTDIR`, => as the number `20`

## 12.3 Querying IO and File objects 399
- `File::Stat` 
  - eturns objects whose attributes correspond to the fields of the stat structure defined by the C library call stat(2)
- `FileTest`


### Getting information from the File class and the FileTest module 

-  methods available as class methods of File and FileTest are almost identical;(alias)
-  Does a file `exist?` 
-  Is the file `empty?` 
-  Is the file a `directory?` A regular `file?` A symbolic `link?`
- also includes `blockdev?`, `pipe?`, `chardev?`, and `socket?`.
-  Is a file `readable?` `Writable?` `Executable?`

- includes `world_readable?` and `world_writable?`, which test for more-permissive permissions. 
  - also includes variants of the basic three methods with `_real` appended. 
  - These test the permissions of the script’s actual runtime ID as opposed to its effective user ID.
 What is the size of this `file?` Is the file empty (zero bytes)?

```rb
FileTest.exist?("/usr/local/src/ruby/README")
FileTest.empty?("/etc/crontab")
FileTest.directory?("/var/log/syslog")
FileTest.file?("/var/log/syslog")
FileTest.symlink?("/var/log/syslog")
FileTest.readable?("/tmp")
FileTest.writable?("/tmp")
FileTest.executable?("/bin/rm")
FileTest.size("/sbin/mkfs")
FileTest.zero?("/tmp/tempfile")
```
#### Getting file information with Kernel#test
- use `test` by passing it two arguments: 
  - the first represents the test, 
  - the second is a file or directory.
    * ?c notation, where c is the character, or as a one-
    * ?d (the test is true if the second argument is a directory), 
    * ?f (true if the second argument is a regular file), 
    * ?z (true if the sec- ond argument is a zero-length file).

### 399 Deriving file information with File::Stat 401
- attributes corresponding to the stat structure in the standard C library
- create a object in either of two ways: 
  * with the new method 
  * with the stat method on an existing File object:
```rb
File::Stat.new("code/ticket2.rb")
File.open("code/ticket2.rb") {|f| f.stat }
```


## 12.4 Directory manipulation with the Dir class 401

- `Dir` class provides useful class and instance methods
```rb
d = Dir.new("/path/to/dierctory")
```

### Reading a directory’s entries 402 

- read entries method 
- using the glob technique.
  - doesn’t return hidden entries
  - allows for wildcard matching and for recursive matching in subdirectories.
```rb
# non-hidden regular files
d = Dir.new("/home/jleo3/.rubies/ruby-2.5.1/lib/ruby/2.5.0/uri")
entries = d.entries
entries.delete_if {|entry| entry =~ /^\./ }
entries.map! {|entry| File.join(d.path, entry) }
entries.delete_if {|entry| !File.file?(entry) }
```

### DIRECTORY GLOBBING
- inspired from shell
```sh
$ ls *.rb
$ rm *.?xt
$ for f in [A-Z]*   # etc.
```
- To glob a directory, you can use the `Dir.glob` method or `Dir.[]`
- params glob pattern + also one or more flag arguments 
-  File::FNM_CASEFOLD => case_insensitive
- FNM_DOTMATCH, which includes hidden dot files
  - 2 flags we combine them with the bitwise OR operator
  - each flag correspond to a integer constant
    - File::FNM_DOTMATCH, for example, is 4.
- an empty array on no match
```rb
Dir.glob("info*") ### => []
Dir.glob("info", File::FNM_CASEFOLD) ### => ["Info", "INFORMATION"]
Dir["*info*"] ### => Dir.glob("*info*", 0)


dir = "/home/jleo3/.rubies/ruby-2.5.1/lib/ruby/2.5.0/uri "
entries = Dir["#{dir}/*"].select {|entry| File.file?(entry) }
print "Total bytes: "
puts entries.inject(0) {|total, entry| total + File.size(entry) }
```

### Directory manipulation and querying 404
-  new directory (mkdir), 
- navigate to it (chdir), add and examine a file, 
- delete the directory (rmdir).
- unlink (delete) the created file

## 12.5 File tools from the standard library 405

- FileUtils 
- Pathname 
- StringIO,
- open-uri

### The FileUtils module 406 
- UNIX like
- `FileUtils.rm_rf` emulates the `rm -rf`
- create a symbolic link from filename to linkname with `FileUtils.ln_s(filename, linkname)`, much in the manner of the ln -s 

```rb

require 'fileutils' ### => true

FileUtils.cp("baker.rb", "baker.rb.bak") ### => nil
FileUtils.mkdir("backup") ### => ["backup"]
FileUtils.cp(["ensure.rb", "super.rb"], "backup") ### => ["ensure.rb", "super.rb"]
Dir["backup/*"] ### => ["backup/ensure.rb", "backup/super.rb"]
```

#### DRYRUN AND NOWRITE MODULES

- `FileUtils::DryRun` representation of a UNIX-style system
- ` FileUtils::NoWrite` don’t accidentally delete, overwrite, or move files, 
```rb
FileUtils::DryRun.rm_rf("backup")  ### rm -rf backup
FileUtils::DryRun.ln_s("backup", "backup_link")  ### ln -s backup backup_link

FileUtils::NoWrite.rm("backup/super.rb")  ###  => nil
File.exist?("backup/super.rb")  ###  => true
```
### The Pathname class 408

- Pathname objects and query and manipulate them
```rb
>> require 'pathname'
=> true
>> path = Pathname.new("/Users/dblack/hacking/test1.rb")
=> #<Pathname:/Users/dblack/hacking/test1.rb>
>> path.basename
=> #<Pathname:test1.rb>
>> puts path.basename
test1.rb
>> path.dirname
=> #<Pathname:/Users/dblack/hacking>
>> path.extname
=> ".rb"

>> path.ascend do |dir|
>>   puts "Next level up: #{dir}"
>> end
```
### The StringIO class 409 

- StringIO class allows you to treat strings like IO objects
- seek through them, rewind them, and so forth.

- Testing file transfor- mations 
  - Ruby’s tempfile class can help you. 

```rb

module DeCommenter
  def self.decomment(infile, outfile, comment_re = /\A\s*#/)
    infile.each do |inline|
      outfile.print inline unless inline =~ comment_re
    end
  end
end


File.open("myprogram.rb") do |inf|
  File.open("myprogram.rb.out", "w") do |outf|
    DeCommenter.decomment(inf, outf)
  end
end

require 'stringio'
require_relative 'decommenter'

string = <<EOM
# This is a comment.
This isn't a comment.
# This is.
   # So is this.
This is also not a comment.
EOM

infile = StringIO.new(string)
outfile = StringIO.new("")

DeCommenter.decomment(infile,outfile)

puts "Test succeeded" if outfile.string == <<EOM
This isn't a comment.
This is also not a comment.
EOM
```
### The open-uri library 411

- retrieve information from the net- work using the HTTP and HTTPS protocols as easily as if you were reading local files
- (require 'open-uri') and use the Kernel#open method with a URI as the argument. You get back a StringIO object containing the results of your request:

```rb
 require 'open-uri'
        rubypage = open("http://rubycentral.org")
        puts rubypage.gets
        `