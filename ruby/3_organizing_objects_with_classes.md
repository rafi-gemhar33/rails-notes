# Organizing objects with classes
- Defining a class lets you group behaviors 
- Everything you handle in Ruby is either an object or a construct that evaluates to an object

## Classes and instances
-  Classes usually exist for the purpose of being instantiated
- Define a class with the `class` keyword
- name begins with a capital letter
- The `new` method is a constructor: 
  * manufacture and return to you a new instance of the class.

Ruby constants, can be overwritten after they’re set. But Ruby prints a warning on reassigning

### Instance methods
- intended for use by all instances of the class, are called instance methods
- Methods that you define for one particular object are called **singleton methods**
EG: `def event` in `ruby/3_organizing_objects_with_classes/Ticket.rb`

### Overriding methods
- When you override a method, the new version takes precedence.

## Reopening classes
- it’s possible to reopen a class and make additions or changes.
eg: `ruby/3_organizing_objects_with_classes/reopening_classes.rb`
- separating class definitions can make it harder for people reading
- One reason to break up class definitions is to spread them across multiple files
- you can `require` a file that contains a class definition
- Ruby has a Time class. It lets you manipulate times,
- Ruby also has a program file called `time.rb`, adding enhancements to the Time class

```rb
t = Time.new
t.xmlschema #  undefined method `xmlschema' for
require 'time'
t.xmlschema # "2022-10-02T06:02:32+05:30"
```

## Instance variables and object state
-  info & data of an instance embodies the state of the object. We need to be able to do the following:
  * Set, or reset, the state of an object.
  * Read back the state.
-  instance variables: storage and retrieval mechanisms for values: 
  * start with a single @ (at sign)
  *  only visible to the object to which they belong
  * can be used by any instance method defined within that class.
```rb
class Person
  def set_name(string)
    @name = string
  end
  def get_name
    @name
  end
end
```
### Initializing an object with state
- optional special method called `initialize`. 
- `.new` calls the `def initialize`

```rb
class Ticket
  def initialize(venue,date)
    @venue = venue
    @date = date
  end
  ...
```

### Setter methods
- =-terminated methods
- Ruby has some specialized method-naming conventions
- Ruby allows to define methods ending with an equal sign (=).
```rb
def price=(amount)
  @price = amount
end
```
- Ruby gives you some syntactic sugar for calling setter methods
- `ticket.price = 63.00` is actually `ticket.price=(63.00)`
- ruby ignores the space before the equal sign & parenthesis is optional.
- it look like assignments but its; "**same but different meme**"
- $#{"%.2f" % ticket.price} : format data into strings

```rb
 class Silly
  def price=(x)
    puts "The current time is #{Time.now}"
  end
end
s = Silly.new
s.price = 111.22 ### The current time is 2018-12-25 09:53:31 -0500
```
- But `=` method calls behave like assignments: the value of the expression

### Attributes and the attr_* method family
- self as default receiver; self is the class object itself
- = method =>  attribute writer
- (without the equal sign) are attribute reader methods
- `attr_reader` => adds setter methods
- `attr_writer` => adds getter methods (with =-terminated_method)
- `attr_accessor` => creates both a reader and a writer method

## Inheritance and the Ruby class hierarchy
-  downward-chaining relationship between two classes (the superclass and the subclass).
- symbol `<`designates Child as a subclass of Parent
- child class instances can access parent class's instance methods
```rb 
class Publication
  attr_accessor :publisher
end
class Magazine < Publication
  attr_accessor :editor
end
```
- Ruby doesn’t allow multiple inheritance
- every class in Ruby, for exam- ple, ultimately descends from the `Object` class,

### the Object class
- class `Object` is almost at the top of the inheritance chart

### BasicObject
- `BasicObject` class comes before Object, blank-slate object
- `BasicObject` instance has only **8** instance methods whereas a new instance of `Object` has **58**

### Classes as objects
- Every class—Object, Person, Ticket—is an instance of a class called Class.
-  class Ticket =>> Ticket = Class.new
- create an anonymous class using Class.new; by appending a code block after the call to new

```rb
c = Class.new do
  def say_hello # will be a instance method
    puts "Hello!" 
  end
end
```

### CLASS/OBJECT CHICKEN-OR-EGG PARADOX
- every object has an internal record of what class it’s an instance of,
- internal record inside the object Class points back to Class itself

### class objects call methods
-  send a message to the object that’s the class rather than to one of the class’s instances.
- Instance methods of the class `Class` can call methods that are defined as instance methods in their class
- `Class` has instance method called `new`.
  - Class has both a class-method version of `new` and an instance-method version
  - the former is called when you write Class.new and the latter when you write Ticket.new. 
- The superclass of Class is Module
- Module; among these are the attr_accessor family of method

- Define class methods in singleton- method style.
  - `def Ticket.most_expensive(*tickets)`

- In Ruby, when you send a message to a class object, you can’t tell where and how the corresponding method was defined.
  - It can be an instance method parent Class

### When, and why, to write a class method
- The `new` method is an excellent example.
- `File.open` is bit like `new`
```rb
class Temperature
  def Temperature.c2f(celsius)
    celsius * 9.0 / 5 + 32
  end
  def Temperature.f2c(fahrenheit)
    (fahrenheit - 32) * 5 / 9.0
end end
```
-  utility methods—methods pertaining to class as a concept but not to a specific to its instances.
- Class methods and instance methods aren’t radically different;
  - their execution is always triggered by sending a message to an object
  - may be a class object.

- Classes are objects.
- Instances of classes are objects, too.
- A class object (like Ticket) has its own methods, its own state, and its own identity. 
    - It doesn’t share these things with instances of itself.

- A note on method notation
  -  **Ticket#price** refers to the instance method price in the class Ticket.
  -  **Ticket.most_expensive** refers to the class method most_expensive in the class Ticket.
  - **Ticket::most_expensive** also refers to the class method most_expensive in the class Ticket.


### Constants up close
-  important and common third ingredient in many classes
- name of every constant begins with a capital letter
```rb
class Ticket
  VENUES = ["Convention Center", "Fairgrounds", "Town Hall"]
```
-  accessed by `Ticket::VENUES`
-  Ruby constants aren’t constant, can change them, in two senses of the word change—and therein lies an instructive lesson.
  - It’s possible to reassign by getting a warning if
  -  Ruby is a dynamic language; anything can change during runtime
  - There’s no warning on altering, because there’s no redefinition of a constant


- Ruby objects are engineered: they derive their functionality from the instance methods defined in their classes and the ancestors of those classes,
- but they’re also capable of “learning” specific, individualized behaviors in the form of singleton methods.

- `is_a?` method to check object has a given class either as its class or ancestral classes.
- In Ruby the behavior or capabilities of an object can deviate from those sup- plied by its class.
- Ruby objects are tremendously flexible and dynamic.

### PREDEFINED CONSTANTS
- Math::PI => math module

## &: shorthand syntax
- abbreviated way of iterating over each of the elements in the tickets array and selecting & performing a method.
- Under the hood, &: uses the Proc object to simplify an otherwise lengthy expression.
