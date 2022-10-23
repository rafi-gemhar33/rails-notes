# 5_the_default_object_self_scope_and_visibility

- Context is important when discerning the value of an identifier or the state of an object
- Self is the "current" or "default" object

## self
- default object/current object, accessible by keyword `self`

### The top-level self object
- outside of any class or module definition block
- `self` shifts in `class`, `module`, & `method` definitions is uniform:
  * the keyword (class, module, or def) marks a switch to a new self
- `main` is a keyword that the default `self` object uses to refer to itself
- If you want to grab `main` you have to assign => `m = self`

### Self inside class, module, and method definitions

#### SELF IN CLASS AND MODULE DEFINITIONS
- In a `class` or `module` definition, `self` is the `class` or `module` object

#### SELF IN INSTANCE-METHOD DEFINITIONS
- when the method is called, self will be the receiver of the message.

#### SELF IN SINGLETON-METHOD AND CLASS-METHOD DEFINITIONS
- a singleton method is executed, self is the object that owns the method,
- self inside a singleton class method is the object whose singleton method(the class itself)

### Class method definition formats:
```rb

class C
  def self.x
    puts "Class method of class C"
    puts "self: #{self}"
  end
end

class C
  class << self
    def x
      # definition of x
    end 
    def y
      # definition of y
    end
  end
end

class D < C
end
D.x  ### => will point self as 'D' in method x invocation"
```

### Self as the default receiver of messages
-  if the receiver of the message is `self`, you can omit the receiver and the dot.
  - `talk => self.talk`
- If both a method and a variable has same name
  * variable takes precedence
  * use `self.talk` or call with an empty argument: `talk()`

- inside the class-definition we can call class methods omit the receiver. Since the Class itself is the self.
- you can’t omit the object-plus-dot, method name ends with an equal sign—a setter method
  - Ruby always interprets the identifier = value as an assignment to a local variable

```rb
class Person
  attr_accessor :first_name, :middle_name, :last_name
  def whole_name
    n = first_name + " " # self.first_name => receiver.first_name
    n << "#{middle_name} " if middle_name
    n << last_name
  end
end
```

### Resolving instance variables through self
- every instance variable belongs to current object.
- instance variables defined outside of instance methods belongs to class(define in class declaration scope & in class methods)
```rb
class C
  def set_v
    # this @v belongs to instances of C
    @v = "I am an instance variable and I belong to any instance of C."
  end

  def show_var
    puts @v
  end
  def self.set_v 
    #  this @v belongs to Class C
    @v = "I am an instance variable and I belong to C."
  end
end
C.set_v
c = C.new
c.set_v
c.show_var

```

## Determining scope
- visibility of identifiers
- instance variables are self bound, rather than scope bound.

### Global scope and global variables
-  global variables, which are recognizable by their initial dollar-sign ($)
-  global variables never go out of scope. (except "thread-local globals,")

#### BUILT-IN GLOBAL VARIABLES
- rarely a good or appropriate choice to use gvars
- All gvars are available in `English.rb` in your Ruby installation
-  we can `require "English"`  we get the slightly friendlier names 
- A few globals have their English-language names preloaded; like `$LOAD_PATH`
`$0` - name of the startup file
`$:($LOAD_PATH)` - directories that make up the path Ruby searches
`$$`(`$PID`) - process ID of the Ruby process
`$.`(`$INPUT_LINE_NUMBER`)

### Local scope
- where the local scopes begin and end,
  - The top level has its own local scope.
  - Every (class, module) has its own local scope, even nested class/module definition blocks.
  - Every method definition (def) has its own local scope;
    - more precisely, every call to a method generates a new local scope, 
    - with all local variables reset to an undefined state.
- Every definition block—whether for a class, a module, or a method—starts a new local scope

- every method call has its own local scope but the self might stay the same;
  * demoed in `5_the_default_object_self_scope_and_visibility/recursion.rb`
- to change `self` without entering a new local scope. the `instance_eval` and `instance_exec`


### Scope and resolution of constants
```rb
module M 
  class C 
    X=2
    class D
      module N
        X=1 
      end
    end 
    D::N::X ## => 1
  end
end
puts M::C::D::N::X #### => 1
puts M::C::X #### =>  2
```
- Constants are interpreted relative to where it occur

#### FORCING AN ABSOLUTE CONSTANT PATH
-  For example, Ruby comes with a String class. But if you create a Violin class, you may also have Strings:
```rb
class Violin
  class String
    attr_accessor :pitch
    def initialize(pitch)
      @pitch = pitch
    end
  end
  def initialize
    @e = String.new("E")
    @a = String.new("A")
    ...etc....
```
- String inside `initialize` resolves to `Violin::String`, 
  * make sure you’re referring to the built-in, original String class
  * constant path separator `::` at the beginning => `::String`
- Like the `/` at the beginning of a pathname, the `::` of constant means "start the search at the top level.


### Class variable syntax, scope, and visibility
- refer `5_the_default_object_self_scope_and_visibility/class_vars.rb:2`
- begin with two at-signs—for example, @@var
- aren’t class scoped, they’re class-hierarchy scoped,(except a few cases)
 - class variables follow their own rules: their visibility and scope don’t line up with those of local variables
 - they cut across multiple values of self
- Parent and Child share the same class variables(pretty stupid if you ask me)
```rb
class Hybrid < Car
end
#  Hybrid.total_count is the same method as Car.total_count, 
# so we must add something like
#  @@total_hybrid_count = 0
```

- Class variables aren’t reissued freshly for every subclass,


### MAINTAINING PER-CLASS STATE WITH INSTANCE VARIABLES OF CLASS OBJECTS
- class methods can be accessed in instance classed by `self.class.class_method`
- refer `5_the_default_object_self_scope_and_visibility/class_vars.rb:55`
classes are objects—and that every object, whether it’s a car, a person, or a class, gets to have its own stash of instance variables.

- If we create instance object to the class itself, and assign manual getters & setters;
  - then this will a per class state not shared to the inheriting classes
```rb
# @total_count is a Car1 class's instance prop & not shared to the inheriting classes
class Car1
  attr_reader :make
  
  class << self
    def total_count
      @total_count ||= 0
    end

    def total_count=(n)
      @total_count = n
    end
  end

  def initialize(make)
    @make = make
    puts "Creating a new #{make}!"
    self.class.total_count += 1
  end
end
```

## method-access rules
-  `private`: `protected`, & `public`
- `Public` is the default access level

### Private methods
- `private` method all method below it are private or:
```rb
private :pour_flour, :add_egg, :stir_batter
```
- refer: `5_the_default_object_self_scope_and_visibility/private.rb`
- you can only call the `private` instance method of a `Class` when `self` is an instance of `Class`.
  - When any instance method of Class is being executed
  - you cannot call them from class methods as well
- private method isn’t the object you’re sending the message to,
  - but which object is self at the time you send the message.

### PRIVATE SETTER (=) METHODS
- declare setters private, you can call it with a receiver—as long as the receiver is self.
- making sure the receiver is exactly self. for private setters

```rb
class Dog
  attr_reader :age, :dog_years
  def dog_years=(years)
    @dog_years = years
  end
  def age=(years)
    @age = years
    self.dog_years = years * 7   #### uses the explicit receiver self.
end
  private :dog_years=
end
```
### Protected methods
-  you can call a protected method on an object x, default object (self) is:
  * an instance of the same class as x 
  * or of an ancestor
  * or descendant class of x’s class.
- the class of self (c1) and the class of the object having the method called on it (c2) are the same or related by inheritance.
- new rules take precedence for instances of D over the rules inherited from C.
```rb
class C
  def initialize(n)
    @n = n
  end
  def n 
    @n
  end
  def compare(c)
    if c.n > n  # n can be called with c as well
      puts "The other object's n is bigger."
    else
      puts "The other object's n is the same or smaller."
    end 
  end

  protected :n
end
```

## top-level methods

- Ruby scripts are in the context of the top-level default object, main,
- main, is an instance of Object

```rb
def talk
  puts "Hello"
end
####### implies ⤵️⤵️⤵️⤵️⤵️
class Object
  private
  def talk
    puts "Hello"
  end
end
```
- these methods not only can but must be called in bareword style, since private can only called on by self
-  the usual exemption of private setter methods, which must be called
with self as the receiver
- private instance methods of Object can be called from anywhere in your code

### Predefined (built-in) top-level methods
- `puts` and `print` are built-in private instance methods of `Kernel`
- `ruby -e 'p Kernel.private_instance_methods.sort'`