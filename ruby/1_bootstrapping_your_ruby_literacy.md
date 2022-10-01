
## Basic Ruby language literacy
- `Ruby` is a programming language. 
- `ruby`, is a computer program. Specifically, it’s the Ruby interpreter
- ruby -e 'puts hola' -e signals that you’re providing an inline script to the interpreter.

### irb 
 utility ships with Ruby 
 cmd line tool
 - executes the code and prints out the result
 - `irb --simple-prompt`

### Arithmetic
 - + , – , * , / 
 - floating-point result if operand is float

### Assignment
- This operation binds a local variable (on the left) to an object (on the right).

### Compare two values
- ==

### Convert to numeric
- "100".to_i

### output methods 
- `puts` adds a newline to the string it outputs
- `print` doesn’t.
- `p` outputs an inspect string, which may contain extra information about what it’s printing.

### input methods
- gets takes the input as a string with new line added


### special objects
- `true`, `false`, `nil`
- `false` and `nil` cause a conditional expression to evaluate as false
- `self` 
  - refers to the default object
  - depends on the execution context
  - Method calls that don’t specify a calling object are called on `self`

### variety of Ruby identifiers
- **Variables**: 
  – Local
    - start with a lowercase letter or an underscore and consist of letters, underscores, and/or digits
    - ruby convention camel case
  – Instance
    - within individual objects
    - always start with a single at-sign (@) 
    -  (@) thereafter of the same character set as local variables
    - can have Capital letter after the at-sign but ot digit
  - Class
    - information per class hierarchy
    - always start with 2 at-sign (@@)
    - can have Capital letter after the at-sign but ot digit
    -  (@@) thereafter of the same character set as local variables
  – Global
    - leading dollar sign ($)
    - ruby convention all capital case
    - special Global vars:  `$:`, `$1`, and `$/`, as well as `$stdin` and `$LOAD_PATH`.

- Constants
  - begin with an uppercase
  - ruby convention either upper camel case (FirstName) or underscore-separated all-uppercase words 
- Keywords
  - predefined, reserved terms
  - like: `def`, `class`, `if`, `__FILE__`, 
- Method names
  - follow the same rules and conventions as local variables
  - except ends with `?, !, or =,`

- method : —a named, executable routine whose execution the object has the ability to trigger

### Objects and methods:
- Ruby sees all data as objects
- Objects are represented either by literal constructors like: `""`, or by variables
- Message sending is achieved via the special dot operator
- message to the right of the dot is sent to the object to the left of the dot

```rb
 x = "100".to_i
#  "100" is called the receiver of the message
# method to_i is being called on the string "100".
```
- Methods can take arguments
- parentheses are usually optional
- barewords like `puts` can be a method call on `self`.

### Class
- every object is an instance of exactly one class.
- launching the object into existence - instantiation.
- ability of objects to adopt behaviors that their class didn’t give them is one of the most central defining principles of the design of Ruby as a language

- `ruby -cw` checks syntax
  - `-c` means check for syntax errors. 
  - `-w` activates a higher level of warning:

### READING & WRITING
```rb
### READING FROM A FILE
num = File.read("temp.dat")


### WRITING TO A FILE
fh = File.new("temp.out", "w")
fh.puts fahrenheit
fh.close
```

## Anatomy of the Ruby installation
- `rbconfig package`
  - interface to a lot of compiled-in configuration information about your Ruby installation
  - `irb` to load it by using irb’s `-r` flag
  ```sh
  irb --simple-prompt -r rbconfig
  RbConfig::CONFIG["bindir"]
  ```

**rubylibdir:**  Ruby standard library
**bindir:**  Ruby command-line tools
**sitedir:**  Your own or third-party extensions and libraries (written in Ruby) 
**sitelibdir:**  Your own Ruby language extensions (written in Ruby)
**archdir:**  Architecture-specific extensions and libraries (compiled, binary files)
**sitearchdir:**  Your own Ruby language extensions (written in C)
**vendordir:**  Third-party extensions and libraries (written in Ruby)

### RbConfig::CONFIG[“rubylibdir”]
- standard library facilities
- **uri.rb** — Tools for uniform handling of URIs
- **fileutils.rb** — Utilities for manipulating files easily from Ruby programs
- **tempfile.rb** — A mechanism for automating the creation of temporary files
- **benchmark.rb** — A library for measuring program performance
### (RbConfig::CONFIG[“archdir”]
-  one level down from rubylibdir
- architecture-specific extensions and libraries. 
- .so, .dll, or .bundle
- C extensions: binary, runtime-loadable files generated from Ruby’s C-language extension code
### RbConfig::CONFIG[“sitedir”])
-  subdirectory called `site_ruby`,
- third-party extensions and libraries
- you can store third-party extensions and libraries
- it has its own subdirectories for Ruby-language and C-language extensions
  - `sitelibdir` and `sitearchdir`, respectively,
### (RbConfig::CONFIG[“vendordir”])
- vendor_ruby with the same subdirectory structure as `site_ruby`. 
- third-party extensions install themselves here.

### Standard Ruby gems and the gems directory
- **RubyGems** utility is the standard way to package and distribute Ruby libraries
  * did_you_mean
  * minitest
  * net-telnet
  * power_assert
  * rake
  * rdoc
  * test-unit
  * xmlrpc
- RubyGems mechanics to only install what’s necessary.
- Ruby will check first to see which of the gems are installed. 
- If, for example, it sees that a minimum acceptable version of rake is already installed, it won’t proceed to install another rake gem.
-  utility listed in the `bindir`

## Ruby extensions and programming libraries
- **standard library**: extensions that ship with Ruby
  - database management, networking, specialized mathematics, XML processing, and many more
  - key to using extensions and libraries is the `require` & `load` methods

### Loading external files and extensions
- `require` and `load` methods
- Extension can refer to any loadable add-on library(written in the C programming)

### “Load”-ing a file
  -  filepath as its argument
  -  current working directory, & look for it in the load path
  -  Ruby interpreter’s load path is a list of directories in which it searches for files you ask it to load
  ```
    - /usr/local/Cellar/rbenv/1.2.0/rbenv.d/exec/gem-rehash
    - /Users/rafi/.rbenv/versions/3.0.2/lib/ruby/site_ruby/3.0.0
      - ~/ruby/site_ruby/3.0.0/x86_64-darwin21
      - ~/ruby/site_ruby
      - ~/ruby/vendor_ruby/3.0.0
      - ~/ruby/vendor_ruby/3.0.0/x86_64-darwin21
      - ~/ruby/vendor_ruby
      - ~/ruby/3.0.0
      - ~/ruby/3.0.0/x86_64-darwin21
  ```
  - navigate relative directories in your load
  - load files names dynamically during the run of the program
  -  load always reloads if called more than once with the same arguments
### “Require”-ing a feature
  - if called more than once with the same arguments, doesn’t reload files
  -  can also feed a fully qualified path 

- Ruby encounters `NoMethodError`, `did_you_mean` kicks in with one or more suggestions 

### require_relative
- convenient to navigate a local directory
```rb
require_relative('path')
# is the same as:
require(File.expand_path('path', File.dirname(__FILE__)))
```

## Out-of-the-box Ruby tools and applications
-  configured as bindir
### ruby — The interpreter
  - CHECK SYNTAX (-c)
  - TURN ON WARNINGS (-w)
  - EXECUTE LITERAL SCRIPT (-e)
  - RUN IN LINE MODE (-l)
  - RUN IN VERBOSE MODE (-v, --verbose)
  - PRINT RUBY VERSION (--version)
  - PRINT SOME HELP INFORMATION (-h, --helP)
  - COMBINING SWITCHES (-cw, -ev)

### irb — The interactive Ruby interpreter
-  it prints out the value of that expression.
- `--noecho` flag
- `--simple-prompt` flag
### rake — Ruby make, a task-management utility
- rake is a make-inspired task-management utility
-  rake reads and executes tasks defined Rakefile.

```rake
namespace :admin do
  desc "Interactively delete all files in /tmp"
  task :clean_tmp do
    Dir["/tmp/*"].each do |f|
      next unless File.file?(f)
      print "Delete #{f}? "
      answer = $stdin.gets
      case answer
      when /^y/
        File.unlink(f)
      when /^q/
        break
      end
    end 
  end
end
```
- rake --tasks
### gem — A Ruby library and application package-management utility 

- gem install gemname
- downloads gem files as needed from (https://rubygems.org/)
- install a gem from a gem file residing locally on your hard disk
  - gem install /home/me/mygems/ruport-1.4.0.gem
- -l (local) restricts all operations to the local domain
- -r (remote) flag. remote gems 
- gem uninstall gemname
- gems can be used via the require method.
- gem

### rdoc and ri — Ruby documentation tools
### erb—A templating system