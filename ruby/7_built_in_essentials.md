# 7_built_in_essentials

- utility classes found in the core library
- built-in vs standard library
  - we must `reqiure` std libs like date, ..., but built ins are like strings, arrays...

## Literal constructors
- creates objects without `.new`
- no new constructor for Integer, Symbol
1. String
  - `""`, `''`
2. Symbol
  - `:symbol`, :`"symbol with spaces"`
3. Array
  - `[]`
4. Hash
  - `{}`, `{"key" => value}`, `{"key": value}`, `{key: value}`
5. Range
  - `0..9`, `0...10`
6. Regexp
  - `/([a-z]+)/`, `//`
7. Proc
  - `->(x,y) { x * y }`, `-> {}`
  ---------

- more than one meaning
  - [] used as hash method
  - {} used as code blocks

## Syntactic Sugar :)
- something looks like an operator but is a method call
- sugary notation in place of `object.method(args)`
- can’t redefine any of the literal object constructors
- `x = 1 + 2` => `x = 1.+(2)`
- overriding `+` method we can use:
  - syntactic sugar of `obj + obj`
  - operator-style sugar `obj += "soup"`
```rb
obj = Object.new
def obj.+(other_obj)
  puts "other object #{other_obj.inspect}"
end
obj + "soup"
```
1. Arithmetic method/ operators
  - `+, -, *, /, %, **`
2. Get/set/append data
  -  `[], []=, <<`
3. .Comparison method/operators
  - `<=>, ==, >, >=, <, <=,`
4. Case equality operator Bitwise operators
  - `===, |, &, ^`

- `||=`, `&&=` are based on `||` and `&&`

### Customizing unary operators
- +1, -100
-  behavior of the `+obj` & `-obj` defining the methods `+@` and `-@`.
```rb
class Banner
  def initialize(text)
    @text = text
  end
  def to_s
    @text
  end
  def +@
    @text.upcase
  end
  def -@
    @text.downcase
  end
  def !
    @text.reverse
  end
end
puts banner  ### Output: Eat at Joe's! 
puts +banner  ### Output: EAT AT JOE'S! 
puts -banner  ### Output: eat at joe's!
puts !banner   # Output: !s'eoJ ta taE 
puts (not banner)   # Output: !s'eoJ ta taE
```

## bang (!) methods.
- by convention permanently modifies its receiver.
- mutates the state of the caller.
-  occur in pairs like: `sort/sort!` `strip/strip!` `reverse/reverse!`
- bang version also has side effects,
- USE ! IN M/M! METHOD PAIRS
- bang doesn’t mean destructive; it means dangerous

## The to_* conversion methods

```rb

obj = Object.new #<Object:0x000001011c9ce0>
obj.new.to_s ### => "#<Object:0x000001030389b0>"
puts obj #<Object:0x000001011c9ce0> ### returns => nil
def obj.to_s
  "I'm an object!"
end
:to_s
puts obj # => I'm an object! ### returns => nil
```

### `to_s` (to string)
- all except instances of `BasicObject` responds to `to_s`
- if overridden on an object, your `to_s` will surface in `puts`. since `puts` calls `to_s` internally I guess!!!
- output of to_s when you use an object in string interpolation.
- calls to `to_s` are automatic, behind the scenes on behalf of `puts` or `interpolation` mechanism.
- puts on an array is a special behavior, a cyclical representation based on calling `to_s` on each of the elements & outputting one per line.

#### inspect 
- exception of instances of BasicObject
- irb uses inspect on every value it prints out
#### display
- display takes an argument: a writable output stream, in the form of a Ruby I/O object. By default, it uses STDOUT, the standard output stream:
- doesn’t automatically insert newline


### to_sym (to sym- bol)

### to_a (to array)
- all objects that include Enumerable, 
  - including Hash, Range, Struct, and Enumerator, implement to_a
- The * operator (“splat” or “star” or “unarray”) does a unwrapping of its operand into its components, those components being the elements of its array representation.
  - the splat turns any array, or any object that responds to to_a, into the equivalent of a bare list.
  - Bare lists are valid syntax only in certain contexts. like inside an array literal or sponge param, or in argument
```rb
array = [1,2,3,4,5] ### => [1, 2, 3, 4, 5]
[*array] ### => [1, 2, 3, 4, 5]
[array] ### => [[1, 2, 3, 4, 5]]
def combine_names(first_name, last_name)
  first_name + " " + last_name
end
names = ["David", "Black"]
puts combine_names(*names)
  ```

### to_i (to integer) && to_f (to float)
- Ruby doesn’t automatically from strings to numbers or like type coersion in 'JS' :)
- turn it into a number explicitly
- incorrect string defaults to 0
  - if starts with digits the nondigit parts are ignored and the conversion is performed only on the leading digits.
- methods like to_s, to_i, and to_f, the result is a new object
```rb
n = gets.to_i
"123hell456".to_i ### => 123
"1.23hello" .to_f ### => 1.23
```
#### STRICTER CONVERSIONS WITH INTEGER AND FLOAT
```rb
Integer("123abc") ### ArgumentError: invalid value for Integer(): "123abc"
Float("-3xyz") ### ArgumentError: invalid value for Float(): "-3xyz"

```
#### STRING ROLE-PLAYING WITH TO_STR
- When an inbuild method expects a string to be a argument, but is called with different type it looks for the `to_str` method:
-  to_str conversion is also used on arguments to the << (append to string) or "" + string
```rb

class Person
  attr_accessor :name
  def to_str
    name
  end
end

david = Person.new
david.name = "David"
puts "david is named " + david + "."  ### Output: david is named David.
```

#### ARRAY ROLE-PLAYING WITH TO_ARY
- When an inbuild method expects a array to be a argument, but is called with different type it looks for the `to_arr` method
```rb
class Person
  attr_accessor :name, :age, :email
  def to_ary
    [name, age, email]
  end
end


david = Person.new
david.name = "David"
david.age = 55
david.email = "david@wherever"
array = []
array.concat(david)
p array ### Output: ["David", 55, "david@wherever"]
```

## Boolean states and objects, and nil
```rb
if (class MyClass end)  # false 
if (class MyClass; 1; end) # Nonempty class definitions evaluate to last value
if (def m; return false; end) ## method definitions are true 
```
-  only objects that have a Boolean value of false are false and nil.
- true and false are keywords.
- class-definition block evaluates to the last expression contained inside it, or nil if the block is empty.
- method definition evaluates to the symbol representing the name of the method

### true and false as objects
- true and false are keywords.
- TrueClass and FalseClass,
```rb
puts true.class    ### Output: TrueClass
puts false.class    ### Output: FalseClass
```

### The special object nil
- instance variable you haven’t initialized: returns nil
- nil is also the default value for nonexistent elements of container and col- lection objects
  * like in array, hash => `[1,2,3][10]   ### => nil`
```rb
nil.to_s  ### => ""
nil.to_i  ### => 0
nil.object_id  ### => 8
```

## Object-comparison 
- module called Comparable
```rb
>> a = Object.new
>> b = Object.new
>> a == a ## or a.eql?(a) or a.equal?(a)
##=> true
>> a == b ## or a.eql?(b) or a.equal?(b)
##=> false
>> a != b
##=> true
```
-  in classes other than Object, `==` and/or `eql?` are typically redefined to do meaningful work for different objects
```rb
string1 = "text"  ###  => "text"
string2 = "text"  ###  => "text"
string1 == string2  ###  => true
string1.eql?(string2)  ###  => true
string1.equal?(string2)  ###  => false
```
- Ruby recommends against redefining equal? so that it can always be used to determine object identity.
-  in the Numeric class (superclass of Integer & Float), `==` performs type conversion before making a comparison but `eql?` doesn’t

### Comparisons and the Comparable module
- If you want custom class to have the all comparison methods: 
  1. Mix a module called Comparable (which comes with Ruby) into MyClass.
  2. Define a comparison method with the name `<=>` as an instance method
- comparison method `<=>` (usually called the spaceship operator or spaceship method)
  - Inside this, you define less than, equal to, and greater than. 
  - consists of a cascading if/elsif/else statement
  - returns -ve, +ve or 0

```rb
class Bid
  include Comparable
  attr_accessor :estimate
  def <=>(other_bid)
    if self.estimate < other_bid.estimate
      -1
    elsif self.estimate > other_bid.estimate
      1
    else
      0
    end
  end
end
#========================or=============================
def <=>(other_bid)
  self.estimate <=> other_bid.estimate
end
```
## Runtime inspection of objects’ capabilities
- Inspection and reflection refer,
-  show string representations of themselves could be described as inspection.

### asking object's methods
  - Listing an object’s methods
  - srt.methods
  - str.singleton_methods
### Querying class and module objects
```rb
String.instance_methods.sort   # without singleton methods
```
### 7.7.3 Filtered and selected method lists
- without those of the class’s ancestors 

- Examining objects at the instance level – obj.private_methods
  – obj.public_methods
  – obj.protected_methods
  – obj.singleton_methods
- Examining objects at the class level
  – MyClass.private_instance_methods – MyClass.protected_instance_methods – MyClass.public_instance_methods


- Struct is a shorthand way for creating a class with read/write attributes