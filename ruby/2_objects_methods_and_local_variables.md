# objects_methods_and_local_variables
## Talking to objects
- object is an entity that listen to messages and act on them
### generic object
- The class concept fits on top of the object concept, not the other way around.
- a class in Ruby is itself an object

```rb
obj = Object.new

def obj.talk
  puts "need to walk the talk"
end

obj.talk

def obj.c2f(c)
  c * 9.0 / 5 + 32
end

obj.c2f(100)
```
- (.) is the message-sending operator.
-  receiver can be, object(literal or self)
-  message being sent is almost always the name of a method 

### Methods that take arguments
-  formal parameters, => variables in method definition
- arguments => values you supply
- The parentheses are optional in both cases; method def & method call
```rb
def obj.c2f c #  method def
obj.c2f 100  #  method call
```

### The return value of a method
-  explicit: return (or) last expression evaluated 

## Crafting an object: 
- the knowledge necessary for the program to do anything useful resides in the object.
- every object in Ruby has a truth value except `false` & `nil`

## innate behaviors of an object
- newly created object isn’t a blank slate
- `methods` method => returns all of the methods call ths object responds to
  * object_id
  * respond_to?
  * send (synonym: __send__)

- `BasicObject.new`, you get a kind of proto-object 
  - it does not have basic methods like: `methods` & `inspect`

- `respond_to?.`
  ```rb
  obj.respond_to? 'talk' #  obj.respond_to? :talk
  ```
  * how to handle the message you want to send it
  * returns true or false 

- Sending messages 
  ```rb
  obj.send 'talk' #  obj.send :talk

  def obj.call_with(request)
    if ticket.respond_to?(request)
      puts ticket.send(request)
    else
      puts "No such information available"
    end
  end

  ```
  - invokes the method passed in as the first param(in the form of symbol/string)
  - "chomps" off the trailing newline character
  - send can call an object’s private methods
  - `__send__` 
  - `public_send` - does not call private methods

## method arguments
### The difference between required and optional arguments
  * you have to supply correct number of arguments on method calls
    - else results in ArgumentError: wrong number

### Argument array or sponge parameter
-  methods allow any number of arguments
```rb
def obj.multi_args(*x)
  puts "I can take zero or more arguments!"
end
def two_or_more(a,b,*c) # requires 2 oe more args
```
- x is assigned an array of values corresponding args passed
- Ruby doesn’t allow for more than one sponge argument
### How to assign default values to arguments
- defaults to assigned value in the definition if argn not supplied
```rb
def default_args(a,b,c=1)
```
### order in which you have to arrange the parameters
- Ruby tries to assign values to as many variables as possible.
- And the sponge parameters get the lowest priority
```rb
def mixed_args(a,b,*c,d)
  p a,b,c,d
end
mixed_args(1,2,3,4,5) # => a=1, b=2, c=[3, 4], d=5
mixed_args(1,2,3) # => a=1, b=2, c=[], d=3

def args_unleashed(a,b=1,*c,d,e)
  p a,b,c,d,e
end
 args_unleashed(1,2,3,4,5) # => a=1,b=2,c=[3],d=4, e=5
 args_unleashed(1,2,3,4) # => a=1,b=2,c=[],d=3, e=4
 args_unleashed(1,2,3) # => a=1,b=1,c=[],d=2, e=3
```
### wrong arguments structure
- we cannot put argument sponge to the left of default-valued
- would result in syntax error
```rb
def broken_args(x,*y,z=1) # syntax error
def broken_args_2(x, *y, z=1, a, b) # syntax error
```

## Local variables and variable assignment
- start with a lowercase letter or an underscore
- made up of alphanumeric characters and underscores
- method definition is a local scope

- str.replace("Goodbye") will replace all referenced values as well
```rb
str = "Hello"
abc = str
str.replace("Goodbye") # str => Goodbye + abc => Goodbye
```
### Reference
- variables contains a reference to a string object(except integers, symbols, boolean, & nil)
- string-replace operation changes reference
- Some objects are stored in variables as immediate values
  * integers, symbols, boolean, & nil
-  integer-bound variables is behind Ruby’s lack of pre and post-increment operators
- if there are no references, the object is considered defunct & its memory space is released and reused.
- References have a many-to-one relationship to their objects
- if you assign a completely new object to a variable that’s already referring to an object, things change
- Reference to an object inside a collection isn’t the same as a reference to the collection.
### References in variable assignment
- Every time you assign to a variable the variable is wiped clean, and a new assignment is made
- Class, global, and instance variables follow the same rules.
- all of the identifier are l-values; serve as the left-hand side of assignment
- Ruby variables labels for objects
- Ruby doesn’t have typed variables.

### References and method arguments
When you call a method with arguments, you’re really trafficking in object reference

### DUPING AND FREEZING OBJECTS
- `dup` 
  - method, which duplicates an object
  - dup a frozen object, the duplicate isn’t `frozen`.
- `freeze`
  - prevents reference from undergoing further change
  - there’s no corresponding unfreeze method
  - Freezing is forever; can only be re assigned
- clone
  - if you clone a `frozen` object, the clone is also `frozen`

### Local variables and the things that look like them
- Ruby sees a bareword identifier it is:
  - A local variable 
  - A keyword
  - A method call

- If the identifier is a keyword, it’s a keyword
- If (=) to the right of the identifier, it’s a local variable
- Otherwise, its assumed to be a local variable or method call; treated the same way by the Ruby interpreter.
Else error:
 **undefined local variable or method `soup' for main:Object`**