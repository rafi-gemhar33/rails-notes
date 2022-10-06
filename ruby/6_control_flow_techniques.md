# Control-flow techniques

Ruby’s control-flow:
- __Conditional execution__—Execution depends on the truth of an expression.
- __Looping__—A single segment of code is executed repeatedly.
- __Iteration__—A call to a method is supplemented with a segment of code that the method can call one or more times during its own execution.
- __Exceptions__—Error conditions are handled by special control-flow rules.

## Conditional code execution
- `if` and related keywords 
- `case` statements

- first successful `if` or `elsif` is executed, and the rest of the state- ment is ignored:
- `else` is optional in `elsif`
```rb
if condition
  # code here, executed if condition is true
end
# ============================================
# INLINE
if x > 10 then puts "do_something" end ## if x > 10; puts x; end
# ============================================
# THE ELSE
if condition
  # code executed if condition is true
else
  # code executed if condition is false
end
# ============================================
# ELSIF KEYWORDS
if condition1
  # code executed if condition1 is true
elsif condition2
  # code executed if condition1 is false # and condition2 is true
elsif condition3
  # code executed if neither condition1
end
# ============================================
# NEGATING CONDITIONS WITH NOT AND !
if not (x == 1)
if !(x == 1)
if not x == 1
```

### UNLESS KEYWORD
- semantics as `if not` or `if !`:
```rb
unless x == 1
# ============================================

unless x > 100
  puts "Small number!"
else
  puts "Big number!"
end
```

### CONDITIONAL MODIFIERS
- conditional modifier at the end of a statement
```rb
puts "Big number!" if x > 100

puts "Big number!" unless x <= 100
```

### THE return VALUE OF IF STATEMENTS
- succeeds =>  evaluates to the code in the successful branch
- doesn’t succeed => returns nil.

### Assignment syntax in condition bodies and tests
- local variable inside blocks didn't succeed is nil(limbo)
```rb
if false
 x = 1
end
p x # => nil
```

### ASSIGNMENT IN A CONDITIONAL TEST
- assignment works as assignments generally do: x gets set to 1.
```rb
if x = 1
  puts "Hi!"
end
# warning: found = in conditional, should be ==
```
- right-hand side of the assignment is itself a 
  - variable, method call, or mathematical expression
  - then you don’t get the warning

### case statements
- Case statement starts with expression
—usually a single object or variable, or any expression
- Only one match, at most, will be executed.
- can put more than one possible match
- case equality method is used in when` === `
  -  `"yes" === answer` => `"yes".===(answer)`
  - By defining `threequal` method in your own class, completely control how objects behave in a case statement
```rb
x = gets.chomp
case x
when "yes", "y"
  puts "YEzzz"
when "no"
  puts "Nooooo"
else
  puts "Wyat..."
end
```

### SIMPLE CASE TRUTH TEST
- case keyword by itself with no test
  - first truthy when clause will be executed

### THE RETURN VALUE OF CASE STATEMENTS
- successful when or else clause => returned value
- fails to find a match, return nil,

## Loops
- while
- until
- loop unconditionally

### Unconditional looping 
- `loop` method doesn’t arguments: except for a block;
- `break` keyword, stop a loop.
- `next` is executed, and control jumps back to the beginning of the loop
```rb
loop { puts "Infinite Loop"}  #### loop codeblock
loop do
  puts "Infinite loop"  ### Infinite Loop
end

n=1
loop do
  n=n+1
  next unless n == 10 
  break
end
```

### Conditional looping with the while
- `while` and `until`
#### while
```rb
#while at beginning
n = 1
while n<11
  puts n
  n +=1
end
puts "Done!"
#=============================================
#while at begin/end, block executed atleast once
begin
  puts n 
end while n < 10
```
#### until
- `until` keyword reverse of `while`
- `until` the condition is true.
- `until` in the post-block position, in conjunction with a `begin/end`
```rb

n=1
until n > 10
  puts n
  n=n+1 
end
```

- post-positioned `while` and `until` you use with a `begin/end`
   - block need not be executed atleast once

```rb
a += 1 until true
# a += 1 statement won’t be executed
```

### Multiple assignment in conditional statements
```rb
if (a,b = [3,4])
  puts a
  puts b
end

# while (a,b = nil) ### will not ryn code block
```

### Looping based on a list of values
for e in [1,2,3]
```rb
celsius = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
for c in celsius
  puts c
end
```

## Iterators and code blocks
- when you call a method on an object, control is passed to the body of the method (a different scope)
- `code block` + `yield`.
  - `yield`(execute) the block

```rb
my_loop
  yield while tue
end

my_loop { puts "My-looping forever!" }
```
- code block is part of the method call, part of its syntax.
- a code block isn’t an argument
- argument & codebloack are two separate constructs

### The anatomy of a method call
- A receiver object or variable (defaulting to self if absent)
- A dot (required if there’s an explicit receiver; disallowed otherwise) 
- A method name (required)
- An argument list (optional; defaults to ())
- A code block (optional; no default)

```rb
loop { puts "Hi" }
loop() { puts "Hi" }
```
- there’s a block, then it can `yield`; if not, it can’t,

### do/end vs {}
```rb
puts array.map {|n| n * 10 }  # puts(array.map {|n| n * 10 })
  # 10
  # 20
  # 30
  # => nil
>> puts array.map do |n| n * 10 end # puts(array.map) do |n| n * 10 end
   #<Enumerator:0x00000101132048>
  # => nil
```
### Implementing times
- times => `Integer#times`
```rb
5.times { |i| puts i}
```
`yield c` => will give c as the block params. :)

### each
```rb
arr.each { |e| puts "***#{e}***" }

class Array
  def my_each
    c = 0
    until c > size
      yield c[0]
      c += 1
    end
    self
  end

  def my_map
    acc = []
    my_each {|e| acc << yield(e) }
    acc
  end
end
```
### Block parameters and variable scope
- have access to variables that already exist 
- closures: objects preserve the local variables that are in scope at the time of their creation
- block-local variables preserve the value of  outer scoped variables
```rb
 celsius.each do |c;fahrenheit|
  fahrenheit = Temperature.c2f(2)
  puts "#{c}\t#{fahrenheit}"
end
```

## Error handling and exceptions
- instance of the class Exception or its children

- ZeroDivisionError 
- `RuntimeError` 
  - The default exception raised by the raise method.
  - `raise`
- NoMethodError 
  - An object is sent a message can’t resolve to a method name;
  - the default method_missing raises this exception.
  - `a.some_unknown_method_name`
- NameError 
  - The interpreter hits an identifier can’t resolve as a variable or method.
  - `a = some_random_identifier`
- IOError 
  - Caused by reading a closed stream, writing to a read-only stream, and similar operations.
  - `STDIN.puts("Don't write to STDIN!")`
- Errno::error 
  - A family of errors relates to file I/O.
  - `File.open(-12)`
- TypeError 
  - A method receives an argument it can’t handle.
  -  `a = 3 + "string"`
- ArgumentError 
  - Caused by using the wrong number of arguments.
  - `def m(x); end; m(1,2,3,4,5)`

-  irb is good about making potentially fatal errors nonfatal

### rescue 
-  good practice to be specific about the exception you wish to handle
- delimited with the `begin` and `end` and has a `rescue` clause in the middle:
```rb
begin
  result = 100 / 0
rescue ZeroDivisionError
  puts "Your number didn't work. Was it zero???"
  exit
end
```

### RESCUE INSIDE METHODS AND CODE BLOCKS
- method or code block provides implicit `begin/end` context.
- explicit begin/end wrapper: inside a block to fine grain the origin of exception

```rb
def open_user_file
  filename = gets.chomp
  fh = File.open(filename)
  yield fh
  fh.close
  rescue
    puts "Couldn't open your file!"
end
# ========================================================================

open_user_file do |filename|
  fh = File.open(filename)
  yield fh
  fh.close
  rescue
    puts "Couldn't open your file!"
end
```

### Debugging with binding.irb(think pry :)
- Execution is paused at this point.
- `Ctrl-D` will achieve the same effect as `exit`.

### Avoiding NoMethodError with the safe navigation operator
- calls next method if the receiver isn’t nil
- `&.`
 ```rb
 tourney_roster2.players&.first&.position
 hash_object&.[](:p)&.[](:o)
 ```

### Raising exceptions explicitly
- without an exception name produces `RuntimeError`
- if raise a message as the only argument, will attach this to `RuntimeError`
```rb
 raise (name_of_the_exception, message)
 raise "Problem!" # => raise RuntimeError, "Problem!"
```

### Capturing an exception
assign the exception object to a variable, special operator `=>` along with the rescue

```rb 
rescue ArgumentError => e
  puts e.backtrace
  puts e.message
end
```

- `raise ZeroDivisionError ###=> raise ZeroDivisionError.new`
- Since in the rescue block we get an instance of the class

### RE-RAISING AN EXCEPTION
Even though there’s re-raise, from inside a rescue clause without any explicit Error class
  - the exception being handled and not the usual generic RuntimeError.

### The ensure clause
- `ensure` clause is executed whether an exception is raised or not.
```rb
def line_from_file(filename, substring)
  ...
  begin
  ...
  rescue ArgumentError => e
    ...
    raise 
  ensure
    fh.close 
  end
  return line
end
```


### Custom exception classes
```rb
class MyNewException < Exception
end
raise MyNewException, "Ho ho ho its my new exception"
```

- inheriting from `StandardError`, `CustomError` 
  - provides a meaningful exception name and 
  - refines the semantics of the rescue operation.