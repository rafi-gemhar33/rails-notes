# Collections central: Enumerable and Enumerator

- collection objects in Ruby typically include the `Enumerable` module.
- the class has to define an instance method called `each`
- methods behind these behaviors are defined in terms of each
-  Enumerable module and the meth- ods it defines on top of each.

- mix Enumerable into your own classes:
- By itself, that doesn’t do much. To tap into the benefits of Enumerable, you must define `each` instance method in your class:


## Ruby collections we’ve studied thus far, along with some of the methods unique to each

| Coll  | Methods                                      |
|-------|----------------------------------------------|
| Array |  `push`, `pop`, `shift`, `unshift`, `slice!` |
| Hash  |  `keys`, `values`, `each_key`, `each_value`  |
| Range |  `cover?`                                    |
| Set   |  `add`, `divide`, `intersect?`, `subset`     |
--------------------------------------------------------

## Gaining enumerability through each
- class that aspires to be enumerable must have an each method
- find works by calling each.
- Some of the methods in enumerable classes are actually overwritten in included classes
- basic each POC
```rb
class Rainbow
  include Enumerable
  def each
    yield "violet"
    yield "indigo"
    yield "blue"
    yield "green"
    yield "yellow"
    yield "orange"
    yield "red"
  end
end

r = Rainbow.new
r.each { |c| puts "Next colour is: #{c}" }
r.find { |c| c.start_with? "y" }

```

```rb
Enumerable.instance_methods(false).sort
[:all?, :any?, :chunk, :chunk_while, :collect, :collect_concat, :count, :cycle, :detect, :drop, :drop_while, :each_cons, :each_entry, :each_slice, :each_with_index, :each_with_object, :entries, :find, :find_all, :find_index, :first, :flat_map, :grep, :grep_v, :group_by, :include?, :inject, :lazy, :map, :max, :max_by, :member?, :min, :min_by, :minmax, :minmax_by, :none?, :one?, :partition, :reduce, :reject, :reverse_each, :select, :slice_after, :slice_before, :slice_when, :sort, :sort_by, :sum, :take, :take_while, :to_a, :to_h, :uniq, :zip]
```


## Enumerable Boolean queries


- `.include?`
- `.all?`    
- `.any?`    
- `.one?`
  - only one
- `.none?`   

- Hash#each yields both a key and a value
- Hashes iterate with two-element arrays
  ```rb
   hash.each {|pair| ... }
   # pair[0]  pair[1]
  ```
- Set iteration works much like array iteration 

- ranges
  - include? works
  - other only work if this can be expressed in a  list of discrete elements
  - if tried on list of float gives `fatal TypeError`

```rb
# Does the array include Louisiana?

states.include?("Louisiana") ### => true
# Do all states include a space?
states.all? {|state| state =~ / / } ### => false
# Does any state include a space?
states.any? {|state| state =~ / / } ### => true
# Is there one, and only one, state with "West" in its name? 
states.one? {|state| state =~ /West/ } ### => true
# Are there no states with "East" in their names?
states.none? {|state| state =~ /East/ } ### => true
```

## searching and selecting

### Getting the first match with `find`(a.k.a. `detect`)
- first element in an array for which the code block
- returns nil if none is found.
-  provide a "nothing found", a Proc object—as an argument 
  - proc will be called if the find fails.

```rb
[1,2,3,4,5,6,7,8,9,10].find {|n| n > 5 } ### => 6
failure = lambda { 11 } ### => #<Proc:0x434810@(irb):6 (lambda)>
over_ten = [1,2,3,4,5,6].find(failure) {|n| n > 10 } ### => 11
r = Rainbow.new ### => #<Rainbow:0x45b708>
```

### Getting all matches with `find_all` (a.k.a. `select`) and `reject`
- `find_all`,=== `select`, always returns an array,
  - returns an empty collection; if none found
- select on a hash or set, you get back a hash or set

- Arrays, hashes, and sets have a bang version, `select!`
  - there is **no** find_all!
- `reject` opposite of select; still returns array
  - `reject!`, specifically for arrays, hashes, and sets.
```rb
a = [1,2,3,4,5,6,7,8,9,10] ### => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
a.find_all {|item| item > 5 } ### => [6, 7, 8, 9, 10]
a.select {|item| item > 100 } ### => []

a.reject {|item| item > 5 } ### => [1, 2, 3, 4, 5]
```

### Selecting on `===` matches with `grep`
- select from an enumerable object based on operator, `===`

- `enumerable.grep(expression)` => `enumerable.select {|element| expression === element }`
- `grep` also can take a optional block, 
  - it yields each element of its result set to the block before returning the results:
- Ranges implement `===` as an `inclusion` test. 

```rb
colors = %w(red orange yellow green blue indigo violet) ### => ["red", "orange", "yellow", "green", "blue", "indigo", "violet"]
colors.grep(/o/) ### => ["orange", "yellow", "indigo", "violet"]

miscellany = [75, "hello", 10...20, "goodbye"] ### => [75, "hello", 10...20, "goodbye"]

miscellany.grep(String) ### => ["hello", "goodbye"]
miscellany.grep(50..100) ### => [75]


### with block
colors.grep(/o/) {|color| color.capitalize } ### => ["Orange", "Yellow", "Indigo", "Violet"]
```

### Organizing selection results with group_by and partition
- `group_by`
  - takes a block and returns a hash, with keys as returning element of the block

- `partition`
  - return 2 sub arrays
  - 0th array selected 
  - 1st array rejected elements
```rb
colors = %w(red orange yellow green blue indigo violet) ### => ["red", "orange", "yellow", "green", "blue", "indigo", "violet"]
colors.group_by {|color| color.size } ### => {3=>["red"], 6=>["orange", "yellow", "indigo", "violet"],
    5=>["green"], 4=>["blue"]}

colors.partition {|color| color.size > 5 } ### => [["orange", "yellow", "indigo", "violet"], ["red", "green", "blue"]]
```

## Element-wise enumerable operations

### Enumerable#first
-  returns the first item
  - takes an optional param & returns that many

### last 
- - takes an optional param & returns that many
- only Array and Range.
- if each yields infinitely(or indefinitely) then issues with last as well

```rb
[1,2,3,4].first ### => 1
[1,2,3,4].first(2) ### => [1,2]
(1..10).first ### => 1

address = { city: "New York", state: "NY", zip: "10027" } ### => {:city=>"New York", :state=>"NY", :zip=>"10027"}
address.first ### => [:city, "New York"]
```

### The take and drop methods
- `take`
  - "take" a certain number of elements from the beginning
  -  it returns an empty array if the array is empty.
- `drop`
  - "drop" a certain number of elements

- `drop_while`
  - It drops the elements if the block returns true
  - method stops if a false returns elements that were not dropped.

```rb

states = %w(NJ NY CT MA VT FL) ### => ["NJ", "NY", "CT", "MA", "VT", "FL"]
states.take(2) ### => ["NJ", "NY"]
states.drop(2) ### => ["CT", "MA", "VT", "FL"]

states.take_while {|s| /N/.match(s) } ### => ["NJ", "NY"]
states.drop_while {|s| /N/.match(s) } ### => ["CT", "MA", "VT", "FL"]
```

### The min and max methods
- are determined by the <=> 
- test based on non default criteria, you can provide a code block:

- `min_by` or `max_by`,
  - which perform the comparison implicitly:
- `minmax`(and the corresponding `minmax_by` method)
  - gives you a pair of values, one for min & max

-  for hashes, `min` and `max` use the keys to determine ordering. 
  - If you want to use values, the `*_by` members of the `min/max` family can help you:

```rb
[1,3,5,4,2].max ### => 5
%w(Ruby C APL Perl Smalltalk).min ### => "APL"
%w(Ruby C APL Perl Smalltalk).min {|a,b| a.size <=> b.size } ### => "C"

%w{ Ruby C APL Perl Smalltalk }.min_by {|lang| lang.size } ### => "C"
%w{ Ruby C APL Perl Smalltalk }.minmax ### => ["APL", "Smalltalk"]
%w{ Ruby C APL Perl Smalltalk }.minmax_by {|lang| lang.size } ### => ["C", "Smalltalk"]

state_hash = {"New York" => "NY", "Maine" => "ME", "Alaska" => "AK", "Alabama" => "AL" }
state_hash.min ### => ["Alabama", "AL"]
state_hash.min_by {|name, abbr| name } ### => ["Alabama", "AL"]
state_hash.min_by {|name, abbr| abbr } ### => ["Alaska", "AK"]
```

## Relatives of each
### `reverse_each`
- on infinite iterator it wii be infinite loop
```rb
[1,2,3].reverse_each {|e| p e * 10 } ### 30, 20 10
```
### each_with_index method (and each.with_index)
- it yields an extra item `index`
- `each_index` only for array & not for hashes & range
- `Enumerable#each_with_index` it’s somewhat deprecated.
- `#with_index` method of the enumerator you get back from calling each
  - you can provide an argument that will be used as the first index value

```rb
letters = {"a" => "ay", "b" => "bee", "c" => "see" }
letters.each_with_index {|(key,value),i| puts i }

array = %w{ red yellow blue }
array.each.with_index do |color, i|
  puts "Color number #{i} is #{color}."
end
names.each.with_index(1) do |pres, i|
  puts "#{i} #{pres}"
end
```

### each_slice and each_cons methods

- each through a collection a certain number of elements at a time
- yielding an array of that many elements to the block on every iteration

- `each_slice`
  - handles each element only once
- `each_cons` 
  - moves through the collection one element at a time and at each point yields an array of n elements
  - takes a new grouping at each element and produces overlapping yielded arrays


```rb
array = [1,2,3,4,5,6,7,8,9,10]
array.each_slice(3) {|slice| p slice }
# [1, 2, 3]
# [4, 5, 6]
# [7, 8, 9]
# [10]
# => nil
array.each_cons(3) {|cons| p cons }
# [1, 2, 3]
# [2, 3, 4]
# [3, 4, 5]
# [4, 5, 6]
# [5, 6, 7]
# [6, 7, 8]
# [7, 8, 9]
# [8, 9, 10]
# => nil
```

### The slice_ family of methods
- return an enumerator; use `to_a`
- `slice_before`
slotting items into groups after the pattern or Boolean test is found
- `slice_after`
slotting items into groups before the pattern or Boolean test is found
- `slice_when` 
  - tests two elements at a time over a collection:

```rb

a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
a.slice_before { |num| num % 2 == 0 }.to_a ### =>  [[1], [2,3], [4,5], [6,7], [8,9], [10]]
a.slice_after { |num| num % 2 == 0 }.to_a ### =>  [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10]]

(1..10).slice_before { |num| num % 2 == 0 }.to_a ### =>[[1], [2,3], [4,5], [6,7], [8,9], [10]]

[1,2,3,3,4,5,6,6,7,8,8,8,9,10].slice_when { |i,j| i == j }.to_a ###  => [[1,2,3],[3,4,5,6],[6,7,8],[8],[8,9,10]]
```
### The cycle method
- `yields` all the elements in the object again and again in a loop
```rb
SUITS = %w(clubs diamonds hearts spades)
RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)

def create_deck(n=1)
cards = []
  SUITS.cycle(n) do |s|
    RANKS.cycle(1) do |r|
      cards << "#{r} of #{s}"
    end
  end
  cards
end
c = create_deck(2)
puts c.size
### => 104
```
### Enumerable reduction with inject
- `inject` method (a.k.a. `reduce`)
- initializing an accumulator
- resetting the accumulator, on return from the block
- without an argument inject takes 
  - initial value for acc and yields elements 
  - starting from the second element in the collection

- Passing the `:+` method to inject tells
  - to use a 0 accumulator and obviates the need for an explicit accumulator.
```rb
[1,2,3,4].inject(0) {|acc,n| acc + n } ### => 10
# simplify the expression:
[1,2,3,4].inject(:+) ### => 10
```

## The map method
-  map always returns an array with same size as the original enumerable.

names = %w(Dav Yuki Chad Amy)
names.map {|name| name.upcase } ### => ["DAV", "YUKI", "CHAD", "AMY"]
name.map(&:upcase)


### The return value of map
- the return value is added to the element of new array
- each exists purely for the side effects
- each returns its receiver

### map! (a.k.a. collect!).
-  `map!` method of Array is defined in Array, not in Enumerable
- for arrays & sets
  - mapping of a set back to itself
```rb
names = %w(David Yukihiro Chad Amy)
names.map!(&:upcase)
```

## Strings as quasi-enumerables
- String doesn’t include Enumerable
- string as a collection of **bytes**, **characters**, code **points**, or **lines**.
- `each_byte`
- `each_char`
- `each_codepoint`
- `each_line`
  - split @ every occurrence of the current value of the global variable `$/`
  - If you change the `$/`, we updated the **delimiter** for what Ruby considers the next line in a string.
- without `each_*` nad in plural form in methods will return array of value
  - `bytes`, `chars`, `codepoints`, `lines`
```rb

str = "abcde"
str.each_byte {|b| p b } ###   97, 98, 99, 100, 101
str.each_char {|c| p c } ### "a", "b", "c", "d", "e"

str = "100\u20ac" ###  => "100?"
str.each_codepoint {|cp| p cp }   ### 49, 48, 48, 8364
#### if you iterate over the same string byte by byte:
str.each_byte {|b| p b } 49, 48, 48, 226, 130, 172

str = "This string\nhas three\nlines"
str.each_line {|l| puts l }  ###   "This string", "has three", "lines"

str.lines ### ["This string", "has three", "lines"]
```

## Sorting enumerables
- `sort` and `sort_by`
- to arrange multiple instances of custom class in order
- don’t have to mix in the `Comparable` module; you just need the spaceship(`<==>`) method.
  1. Define a comparison method for the class (<=>).
  2. Place the multiple instances in a container, probably an array.
  3. Sort the container.

### Defining sort-order logic with a block
- block takes two arguments, a and b
```rb
year_sort = paintings.sort do |a,b|
  a.year <=> b.year
end

["2",1,5,"3",4,"6"].sort {|a,b| a.to_i <=> b.to_i } ### => [1, "2", "3", 4, 5, "6"]
```

### Concise sorting with sort_by
- always takes a block
- sort_by figures out that you want to do the same thing to both
```rb
["2",1,5,"3",4,"6"].sort_by {|a| a.to_i } ### => [1, "2", "3", 4, 5, "6"] #### Or 
sort_by(&:to_i)
```

### Sorting enumerables and the Comparable module
- Don't need `Comparable` module for your objects to sort,
  - but you do need to include it to compare.

visit: `/Users/rafi/Desktop/rails-notes/ruby/10_collections_central_enumerable_and_enumerator/custom_sort.rb`


## Enumerators and the next dimension of enumerability
- iterator is a method that yields one or more values to a code block
- enumerator is an object;
- either you call `Enumerator.new` with a **code block**, so that the code block contains the each logic you want the enumerator to follow;
-  you create an enumerator based on an existing enumerable object (an array, a hash, and so forth) 

### Creating enumerators with a code block
```rb
e = Enumerator.new do |y|
  y << 1
  y << 2
  y << 3
end

e.to_a ### => [1, 2, 3]
e.map {|x| x * 10 } ### => [10, 20, 30]
e.select {|x| x > 1 } ### => [2, 3]


e = Enumerator.new do |y|
  (1..3).each {|i| y << i }
end
```
- `y` is a `yielder`, an instance of `Enumerator::Yielder`
- when enumerator get an each call, you should yield 1, then 2, then 3
  - `<<` method serves to instruct the yielder as to what it should yield.
  - You can also write `y.yield(1)`
- you don’t yield from the block, you populate your yielder (y, in the first examples) 

```rb
a = [1, 2, 3, 4, 5]
e2 = Enumerator.new do |y|
  total = 0
  until a.empty?
    total += a.pop
    y << total
  end
end

e.take(2) ### => [5, 9]
a ### => [1, 2, 3]
e.to_a ### => [3, 5, 6]
a ### => []
```

### Attaching enumerators to other objects
- parasitic each-binding
- create an enumerator calling `enum_for` (a.k.a. `to_enum`)
-  first argument the name of the method onto which the enumerator will attach
- This argument defaults to `:each`, although it’s common to attach the enumerator to a different method
- can also provide further arguments to `enum_for`
- such arguments are passed through to the method to which the enumerator is being attached
- the starting string `"Names: "` has had some names added to it, but it’s still alive inside the enumerator. 
  - That means if you run the same inject operation again, it adds to the same string
  - So watch for side effects

`Enumerator.new(obj, method_name, arg1, arg2...)` => `obj.enum_for(method_name, arg1, arg2...)`
```rb

names = %w(David Black Yukihiro Matsumoto)
e = names.enum_for(:select)

e.each {|n| n.include?('a') }  ###  Output: ["David", "Black", "Matsumoto"]
e = names.enum_for(:inject, "Names: ") ### => #<Enumerator: ["David", "Black", "Yukihiro", "Matsumoto"]:inject("Names:")>
e.each {|string, name| string << "#{name}..." } ### => "Names: David...Black...Yukihiro...Matsumoto..."
e.each {|string, name| string << "#{name}..." } ### => "Names: David...Black...Yukihiro...Matsumoto... David...Black...Yukihiro...Matsumoto..."
```

### Implicit creation of enumerators by blockless iterator calls
- By definition, an iterator is a method that yields one or more values to a block. 
-  if there’s no block, most built-in iterators return an enumerator when they’re called without a block
- `each_byte` iterates over the bytes in the string and returns its receiver
- if you call each_byte with no block, you get an enumerator:

```rb
str = "Hello"  ### => "Hello"
str.each_byte {|b| puts b } ### 72, 101, 108, 108, 111  ### => "Hello"
str.each_byte  ### => #<Enumerator: "Hello":each_byte> 
str.enum_for(:each_byte)
```

## Enumerator semantics and uses

### How to use an enumerator’s each method
- An enumerator’s `each` method is hooked up to a method on another object,
  - possibly a method other than `each`. If you use it directly, it behaves like that other method, including with respect to its return value.
  - This can produce some odd-looking results where calls to `each` return filtered
- an enumerator’s `each` serves as a kind of conduit to the method from which it pulls its values and behaves the same way in the matter of return value
```rb
array = %w(cat dog rabbit) ### => ["cat", "dog", "rabbit"]
e = array.map ### => #<Enumerator: ["cat", "dog", "rabbit"]:map>
e.each {|animal| animal.capitalize } ### => ["Cat", "Dog", "Rabbit"]
```

### THE UN-OVERRIDING PHENOMENON

- If a `class` defines `each` and `includes Enumerable`, 
  - its instances automatically get `map`, `select`, `inject`, and all the Enumerable’s methods.
  - All those methods are defined in terms of `each`.
- enumerator is a different object from the collection from which it siphons its iterated object
```rb
h = { cat: "feline", dog: "canine", cow: "bovine" } ### => {:cat=>"feline", :dog=>"canine", :cow=>"bovine}
h.select {|key,value| key =~ /c/ } ### => {:cat=>"feline", :cow=>"bovine }
e = h.enum_for(:select) ### => #<Enumerator: {:cat=>"feline", :dog=>"canine", :cow=>"bovine"}:select> 
e.each {|key,value| key =~ /c/ } ### => {:cat=>"feline", :cow=>"bovine }
e = h.to_enum ### => #<Enumerator: {:cat=>"feline", :dog=>"canine", :cow=>"bovine"}:each>
h.each { } ### => {:cat=>"feline", :dog=>"canine", :cow=>"bovine}
e.each { } ### => {:cat=>"feline", :dog=>"canine", :cow=>"bovine}

############# call to the select method of the enumerator, not the hash.############# 
e.select {|key,value| key =~ /c/ } ### => [[:cat, "feline"], [:cow, "bovine"]]

```

### Protecting objects with enumerators
- an enumerator can serve as a kind of gateway to a collection object such that it allows iteration and examination of elements but disallows destructive operations.

```rb
a = [1,2,3,4,5] ### => [1, 2, 3, 4, 5]
e = a.to_enum ### => #<Enumerator: ...>
e << 6 ### undefined method `<<' for #<Enumerator
```

### Fine-grained iteration with enumerators
- Enumerators maintain state
- `.next`
- `.rewind`
- use an enumerator on a non-enumerable object.
  - your object to have a method that yields something 
  - so the enumerator can adopt that method as the basis for its own each method.
```rb
names = %w(David Yukihiro)
e = names.to_enum
puts e.next  ### David
puts e.next  ### Yukihiro
e.rewind
puts e.next  ### David
```

### Adding enumerability with an enumerator
- an enumerator is an enumerable object whose `each` method operates as a kind of siphon, 
  - pulling values from an iterator defined on a different object.
```rb
module Music
  class Scale
    NOTES = %w(c c# d d# e f f# g a a# b)

    def play
      NOTES.each {|note| yield note }
    end
  end
end

scale = Music::Scale.new
enum = scale.enum_for(:play)

p enum.map {|note| note.upcase }  ### ["C", "C#", "D", "D#", "E", "F", "F#", "G", "A", "A#", "B"]
p enum.select {|note| note.include?('f') }  ## ["f", "f#"]
```

### Enumerator method chaining
Want to print out a comma-separated list of uppercased animals beginning with A through N ? Just string a few methods together:
animals = %w(Jaguar Turtle Lion Antelope)
animals.select {|a| a[0] < "M"}.map(&:upcase).join(", ")

### Economizing on intermediate objects
- chain the enumerator directly to another method, without block
```rb
animals.each_slice(2).map do |predator, prey|
  "Predator: #{predator}, Prey: #{prey}\n"
end ### => ["Predator: Jaguar, Prey: Turtle\n", "Predator: Lion, Prey: Antelope\n"]
```

#### Indexing enumerables with with_index
- with_index can be chained to any enumerator
- with_index method generalizes what would otherwise be a restricted func- tionality.
```rb
('a'..'z').map.with_index {|letter,i| [letter, i] } ### Output: [["a", 0], ["b", 1], etc.]
```

### Exclusive-or operations on strings with enumerators
- obfuscation technique
```
"a" ^ "#" => 97 ^ 35 => 1100001 ^ 100011 ### 1000010 => 66
(a ^ b) ^ b == a
```
```rb
class String
  def ^(key)
    kenum = key.each_byte.cycle
    each_byte.map {|byte| byte ^ kenum.next }.pack("C*")
  end
end

str = "Nice little string." ### => "Nice little string."
key = "secret!" ### => "secret!"
x = str ^ key ### => "=\f\x00\x17E\x18H\a\x11\x0F\x17E\aU\x01\f\r\x15K"
orig = x ^ key ### => "Nice little string."
```
- `pack`
 - turns an array into a string, interpreting each element of the array in a manner specified by the argument.
  - "C*"
    - treat each element of the array as an unsigned integer representing a single character (that’s the "C"), and process all of them (that’s the "*")

-  if you `XOR`, say, a `UTF-8` against an `ASCII` string twice, 
  - you’ll get back a string encoded in ASCII-8BIT. 
  - To guard against this, add a call to `force_encoding`
  ```rb
  each_byte.map {|byte| byte ^ kenum.next }.pack("C*").
                         force_encoding(self.encoding)
  ```

## Lazy enumerators
- get a finite result from an infinite collection by using a lazy enumerator.
- `Float::INFINITY`
```rb
(1..Float::INFINITY).select {|n| n % 3 == 0 }.first(10) ### runs infinitely
(1..Float::INFINITY).lazy.select { |n| n % 3 == 0 }.first(10)

#  call force on the result of take
my_enum = (1..Float::INFINITY).lazy.select {|n| n % 3 == 0 } ### => #<Enumerator::Lazy: #<Enumerator::Lazy: 1..Infinity>:select>
my_enum.take(5).force ### => [3, 6, 9, 12, 15]
my_enum.take(10).force ### => [3, 6, 9, 12, 15, 18, 21, 24, 27, 30]
```

### FizzBuzz with a lazy enumerator
```rb
def fb_calc(i)
  case 0
  when i % 15
    "FizzBuzz"
  when i % 3
    "Fizz"
  when i % 5
    "Buzz"
  else i.to_s
  end
end

def fb(n)
  (1..Float::INFINITY).lazy.map {|i| fb_calc(i) }.first(n)
end
```


## MISC
10.step(25,3))
  - iteration from 10 to 25 in steps of 3 (10, 13, 16, 19, 22, 25)

`Kernel#rand.` 
  - With no argument, this method generates a random floating-point 0 <= n < 1
  - With an argument i, it returns a random integer n such that 0 <= n < i

```rb
cheapest, priciest = [pa1, pa2, pa3].minmax
Painting.new(1000).clamp(cheapest, priciest).object_id == priciest.object_id ## => true
```
clamp method, which is similar to between? If the Painting’s price is less than the first argument (cheapest), clamp returns the first argument. If it's greater than the second argument (priciest),
