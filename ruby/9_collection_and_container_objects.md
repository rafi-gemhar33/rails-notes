# Collection and container objects

- mix in the Enumerable module

## CHEAT SHEET
### ARRAY 

|   **Action**                  |  **combinations**            |
--------------------------------|-------------------------------
| Retrieve single element       | [index], slice(index)        |
| Retrieve multiple elements    | [index, length], [start..finish], slice(index, length), slice(start..finish), values_at(index1, index2...) |
| Retrieve nested elements      | dig(index1, index2...)       |
| Set single element            | [index]=                     |
| Set multiple elements         | [index, length]=, ??? slice(index, length)                 |
| Delete elements               | slice!(index), slice!(index, length), slice!(start..finish) |
| Add element to beginning      | unshift                      |
| Remove element from end       | pop, pop(length)             |
| Remove element from beginning | shift, shift(length)         |
| Add element to end            | push, push(el1, el2...), <<  |
----------------------------------------------------------------
## Arrays and hashes in comparison
- array is an ordered collection 
- Hashes store objects in a key and a value pair.
 - Any Ruby object can serve as a hash key and/or value
  - hashes exhibit a kind of “meta-index” property
```rb
hash.each_with_index {|(key,value),i|  ### 1 
  puts "Pair #{i} is: #{key}/#{value}"
}
```

>> _### 1_ block parameters (key,value) serve to split apart an array.
>>   - If the parameters were key,value,i, 
>>   - then the parameter key would end up bound to the entire [key,value] array; value would be bound to the index; and i would be nil

## Collection handling with arrays

### Creating a new array
##### `Array.new`
- takes (size, default_values & a block)
  - default_values: all the elements of the array are initialized to the same object
#### LITERAL ARRAY CONSTRUCTOR: `[ ]`
- `a = []`
- square bracket has a lot of meaning with context
  - array construction, array indexing, hash indexing
  - character classes in regular expressions,
  - delimiters in %q[]
  - calling of an anonymous function
#### THE ARRAY METHOD
- create an array is with a method Array()
- capitalized methods tend to have the same names as classes to which they’re related.
- If argument has a to_ary method defined, then Array calls that to generate
```rb
string = "A string" ### => "A string"
string.respond_to?(:to_ary) ### => false
string.respond_to?(:to_a) ### => false
Array(string) ### => ["A string"]
def string.to_a
  split(//)
end ### => nil
Array(string) ### => ["A", " ", "s", "t", "r", "i", "n", "g"]
```

#### THE %W AND %W ARRAY CONSTRUCTORS
- %q style
- space-separated strings you put inside delimiters
  - whitespace character, you need to escape
- for double quoted strings, you can use %W
```rb
%w(Joe Leo III) ### => ["Joe", "Leo", "III"]
%w{ Joe Leo III } ### => ["Joe", "Leo", "III"]
%W(Joe is #{2018 - 1981} years old.) ### => ["David", "is", "37", "years", "old."]

```

#### %I AND %I ARRAY CONSTRUCTORS
- arrays of symbols using %i and %I. 
- The i/I distinction single vs double-quoted interpretation
```rb
%i(a b c) ### => [:a, :b, :c]
d = "David" ### => "David"
%I("#{d}") ### => [:"\"David\""]
```

### try_convert
- looks for a conversion method on the argument. If exists, it gets called; else returns nil.
- if returns an object other than the class to which conversion is being attempted, 
  - it’s a fatal error (TypeError).
```rb
obj = Object.new ### => #<Object:0x000001028033a8>
Array.try_convert(obj) ### => nil
def obj.to_ary
  [1,2,3]
end ### => :to_ary
Array.try_convert(obj) ### => [1, 2, 3]
def obj.to_ary
  "Not an array!"
end ### => :to_ary
Array.try_convert(obj) ### => TypeError: can't convert Object to Array (Object#to_ary gives String...
```

### Inserting, retrieving, and removing array elements

- Array#[ ] or Array#[ ]=
  - `[]=`
  - ` a[0] = "first" => a.[]=(0,"first")`
  - a second argument, it’s treated as a length a number of elements to set or retrieve. 
  - In the case of retrieval, the results are returned inside a new array.
  - can provide a range to [ ] or [ ]= 
- `slice`
  - synonym for the [ ] method: .
  - `slice!` removes the items permanently

- `values_at`
  - one or more arguments for indexes and 
  - returns an array consisting of the values at those indexes

- `dig`
  - extract elements from nested arrays
  - each nested element within a multidimensional array
```rb
a = %w(red orange yellow purple gray indigo violet) ### => ["red", "orange", "yellow", "purple", "gray", "indigo", "violet"]
a[3,2] ### => ["purple", "gray"]
a[3,2] = "green", "blue" ### => ["green", "blue"]
a ### => ["red", "orange", "yellow", "green", "blue", "indigo", "violet"]
#=============================== range ===============================

a[3..5] ### => ["green", "blue", "indigo"]
a[1..2] = "green", "blue" ### => ["green", "blue"]
a ### => ["red", "green", "blue", "green", "blue", "indigo", "violet"]
#============================== values_at ============================

array = %w(the dog ate the cat)
articles = array.values_at(0,3)
p articles # Output: ["the", "the"]

#============================== dig ============================

arr = [[1], 2, 3, [4, 5]] ### => [[1], 2, 3, [4, 5]]
arr[0] ### => [1]
arr[3][0] ### => 4

arr.dig(3,0) ### => 4
```
### MANIPULATING THE BEGINNINGS AND ENDS OF ARRAYS
- `unshift` 
  - add at 0
  - can take more than one argument.
- `push`
  - add to the end of an array
  - can take more than one argument.
- `<< ` 
  - which places at the end of array
  - only one argument
- `shift` 
  - removed from 0
  - takes integer param 
- `pop`
  - removed from end
  - takes integer param 
```rb
# Inserting
a = [1,2,3,4]
a.unshift(0)  ### => [0,1,2,3,4]
a = [1,2,3,4]
a.push(5) ### => [1,2,3,4,5]
a = [1,2,3,4,5] 
a.push(6,7,8) ### => [1,2,3,4,5,6,7,8]
a << 9 ### => [1,2,3,4,5,6,7,8,9]

# Removing
a = [1,2,3,4,5] ### => [1, 2, 3, 4, 5]
a.pop ### => 5
p a ### => [1, 2, 3, 4]
a.shift ### => 1
p a ### => [2, 3, 4]

a = %w{ one two three four five } ### => ["one", "two", "three", "four", "five"]
a.pop(2) ### => ["four", "five"]
a ### => ["one", "two", "three"]
a.shift(2) ### => ["one", "two"]
a ### => ["three"]
```

###  Combining arrays with other arrays
- `concat`
  - permanently changes the contents of its receiver
- `+` method
  - returns a new combined array
- `replace`
  - replace operation is different from reassignment
 
```rb
>> [1,2,3].concat([4,5,6]) ### => [1, 2, 3, 4, 5, 6]

>> a = [1,2,3] ### => [1, 2, 3]
>> b = a + [4,5,6] ### => [1, 2, 3, 4, 5, 6]
>> a ### => [1, 2, 3]

>> a.replace([4,5,6]) ### => [4, 5, 6]
>> a ### => [4, 5, 6]

>> a = [1,2,3] ### => [1, 2, 3]
>> b = a ### => [1, 2, 3]

>> a.replace([4,5,6]) ### => [4, 5, 6]
>> b ### => [4, 5, 6]
>> a = [7,8,9] ### => [7, 8, 9]
>> b ### => [4, 5, 6]
```
### Array transformations
- `flatten`
  - un-nesting of inner arrays.
  - specify how many levels
  - default is full
  - `flatten!`: permanently changes

- `reverse`
  - `reverse!`: permanently changes

- `join`
  -  string representation of all the elements
  - optional parameter which joins

- `*` method. 
  join an array: the 
  looks like you’re multiplying the array with string, actually a joining operation:

- `uniq`
  -  duplicate elements removed(== method)
  - `uniq!` : permanently changes

- `compact`
  - removes all nil
  - `compact!` : permanently changes
```rb 
array = [1,2,[3,4,[5],[6,[7,8]]]] ### => [1, 2, [3, 4, [5], [6, [7, 8]]]]
array.flatten ### => [1, 2, 3, 4, 5, 6, 7, 8]
array.flatten(1) ### => [1, 2, 3, 4, [5], [6, [7, 8]]]
array.flatten(2) ### => [1, 2, 3, 4, 5, 6, [7, 8]]

[1,2,3,4].reverse ### => [4,3,2,1]

["abc", "def", 123].join ### => "abcdef123"

["abc", "def", 123].join(", ") ### => "abc, def, 123"

a = %w(one two three) ### => ["one", "two", "three"]
a * "-" ### => "one-two-three"

[1,2,3,1,4,3,5,1].uniq ### => [1, 2, 3, 4, 5]

zip_codes = ["08902", nil, "10027", "08902", nil, "06511"] ### => ["08902", nil, "10027", "08902", nil, "06511"]
zip_codes.compact ### => ["08902", "10027", "08902", "06511"]
```

### Array querying

| method           | what does...               |
-------------------|----------------------------|
| a.size           | (synonyms: length, count) Number of elements in the array  | 
| a.empty?         | True if a is an empty array; false if it has any elements  | 
| a.include?(item) | True if the array includes item; false, otherwise  | 
| a.count(item)    | Number of occurrences of item in array  | 
| a.first(n=1)      | First n elements of array  | 
| a.last(n=1)      | Last n elements of array  | 
| a.sample(n=1)    | n random elements from array  | 
-----------------------------------------------------

## Hashes

- key and any value can be any Ruby object.
- quick lookup in better- than-linear time.
- remember their key insertion order and observe that order when you iterate 
- you can’t have duplicate keys; (old entry is overwritten)

### Creating a new hash
**There are 4 ways:**
1. literal constructor (curly braces)
   - either the `=>` operator or `{ key: value }`(only symbol keys)
   - last comma optional
2. Hash.new method
   - creates an empty hash
   - optional param acting default value for nonexistent hash keys. 
3. Hash.[] method (a square-bracket class method of Hash)
   - comma-separated list of items,
   - even number of arguments, alternating keys and values
   - odd number of arguments, a fatal error is raised,
   - array of arrays, where each subarray consists of two elements.
   - pass in anything that has a method called `to_hash`
4. top-level method whose name is Hash
   -  with an empty array (`[]`) or `nil`, it returns an empty hash
   - Otherwise, it calls `to_hash` on its single argument.
   - fatal `TypeError` if argument not responding `to_hash`

```rb
Hash["Connecticut", "CT", "Delaware", "DE" ] ### => {"Connecticut"=>"CT", "Delaware"=>"DE"}
Hash[ [[1,2], [3,4], [5,6]] ] ### => {1=>2, 3=>4, 5=>6}
```

### Inserting, retrieving, and removing hash pairs

#### ADDING A KEY/VALUE PAIR TO A HASH
- `[]=`
  - method plus syntactic sugar.
- `store`
  - synonymous to []=
```rb 
hash[:soup] = "good soup"  ### >>> hash.[]() = [:soup, "good soup"]
hash.store(:bread, "breaking bread")

h = Hash.new
h["a"] = 1
h["a"] = 2
puts h["a"]
```

#### RETRIEVING VALUES FROM A HASH
- `[]` method.
  - [] gives you either nil/ default for nonexistent keys

- `#fetch(arg_1, arg2)`
  - fetch raises an exception, for nonexistent keys
  - second argument to fetch, that argument will be returned, instead of an exception
  - pass a block to `fetch` or `fetch_values`. Rather than raising an error

- `fetch_values(*args)`
  - raises a `KeyError` if the requested key isn’t found:
  - pass a block to `fetch` or `fetch_values`. Rather than raising an error

- `values_at(*args)`
  - returns an array consisting of array
  - adds nil to nonexistent keys in the array

- `Hash#dig(*args)`
  - takes one or more symbols as arguments:
  - returns nil if drilling fails

```rb
state_hash = { "New Jersey" => "NJ",
               "Connecticut" => "CT",
               "Delaware" => "DE" }

state_hash["Connecticut"]   # => "CT"
state_hash.fetch("Connecticut")   # => "CT"
state_hash.fetch("Nebraska", "Unknown state")   # => "Unknown state"

two_states = state_hash.values_at("New Jersey","Delaware") # => ["NJ","DE"]

state_hash.fetch_values("New Jersey", "Wyoming") # => KeyError (key not found: "Wyoming")
state_hash.fetch_values("New Jersey", "WYOMING") do |key|
  key.capitalize
end ### => ["NJ", "Wyoming"]
```

### Specifying default hash values and behavior
- `Hash#new(arg_1)`
  - optional param acting default value for nonexistent hash keys. 
  -  supplying a code block to execute every time a nonexistent key is referenced
    - Two objects will be yielded to the block: the hash and the (nonexistent) key
- `Hash#default(arg_1)`
  - on an already existing hash with the default method
```rb
h = Hash.new ### => {}
h["no such key!"] ### => nil

h = Hash.new(0) ### => {}
h["no such key!"] ### => 0

h = Hash.new {|hash,key| hash[key] = 0 }
```

### Combining hashes with other hashes
- destructive
  - `update`
    - updates the callee
  - `merge!`
    - synonym to update
- non destructive
  - `merge`
    - returns a third hash and leaves the original unchanged:

```rb
h1 = { first:  "Joe",
       last:   "Leo",
       suffix: "III" }
h2 = { suffix: "Jr." }
h1.update(h2)
h1[:suffix] ### => "Jr."

h1 = { first:  "Joe",
       last:   "Leo",
       suffix: "III" }
h2 = { suffix: "Jr." }
h3 = h1.merge(h2)  ### => {:first=>"Joe",:last=>"Leo",:suffix=>"Jr."}
h1[:suffix] ### => "III"
```

### Hash transformations
#### SELECTING AND REJECTING ELEMENTS FROM A HASH

- `select` 
  - Any pair for which the block returns a true value will be included in the result hash:

- `select!` 
  - the destructive brother of select
  - returns nil if hash doesn’t change

- `reject`
  - opposite of select

- `reject!`
  - the destructive brother of reject
  - returns `nil` if hash doesn’t change

- `keep_if`
  - the destructive brother of select
  - returns the hash if hash doesn’t change

- `delete_if`
  - the destructive brother of reject
  - returns the hash if hash doesn’t change

- `compact`
  - eliminating any keys containing nil values:

```rb
h = Hash[1,2,3,4,5,6]
h.select {|k,v| k > 1} ### => {3=>4, 5=>6}
h.reject {|k,v| k > 1} ### => {1=>2}

{ street: "127th Street", apt: nil, borough: "Manhattan" }.compact=  ### => {:street=>"127th Street", :borough=>"Manhattan"}
```

- `Hash#invert`
  - flips the keys and the values.
  - hash keys are unique, but values aren’t, when you turn duplicate values into keys, one of the pairs is discarded

- `Hash#clear`
  - empties the hash:

- `replace`

```rb
h = { 1 => "one", 2 => "two" } ### => {1=>"one", 2=>"two"}
h.invert ### => {"two"=>2, "one"=>1}

h = { 1 => "one", 2 => "more than 1", 3 => "more than 1" } ### => {1=>"one", 2=>"more than 1", 3=>"more than 1"}
h.invert ### => {"one"=>1, "more than 1"=>3}

{1 => "one", 2 => "two" }.clear ### => {}

{ 1 => "one", 2 => "two" }.replace({ 10 => "ten", 20 => "twenty"}) ### => {10 => "ten", 20 => "twenty"}
```

### Hash querying

| Method name           | Sample call Meaning               |
|-----------------------|-----------------------------------|
| h.has_key?(1)         | True if h has the key1            |
| h.include?(1)         | Synonym for has_key?              |
| h.key?(1)             | Synonym for has_key?              |
| h.member?(1)          | Synonym for has_key?              |
| h.has_value?("three") | True if any value in h is "three" |
| h.value?("three")     | Synonym for has_value?            |
| h.empty?              | True if h has no key/value pairs  |
| h.size                | Number of key/value pairs in h    |
-------------------------------------------------------------

### Hashes as method arguments
- last argument in the argument list is a hash,
  - write the hash without curly braces.
- Hashes as first arguments
  - curly braces around the hash but also put the entire argument list in parentheses.
```rb
def add_to_city_database(name, info)
  p name
  p info
end

add_to_city_database("tokyo", country: "JAPAN", continent: "ASIA", population: 7000000,)
```

### named (keyword) arguments
- “unwraps” hashes in your methods.
- keyword arguments optional by supplying default values
- double- starred argument 
  - sponges  all unknown keyword arguments into a hash
```rb
def m(a:, b:)
  p a  # 1
  p b  # 2 
end ## => :m
m(a: 1, b: 2) ## => [1, 2]

def m(a: 1, b: 2)   ### default values


def m(a: 1, b: 2, **c)
  p a  # 1
  p b  # 2
  p c  # {:x=>1, :y=>2}
end ### => :m
m(x: 1, y: 2) ### => [1, 2, {:x=>1, :y=>2}]



def m(x, y, *z, a: 1, b:, **c, &block)
  p x  # 1
  p y  # 2
  p z  # [3, 4, 5]
  p a  # 1
  p b  # 10
  p c  # {:p=>20, :q=>30}
end ### => :m
m(1,2,3,4,5,b:10,p:20,q:30) ### => [1, 2, [3, 4, 5], 1, 10, {:p=>20, :q=>30}]
```

## Ranges
- start point and an end point
- inclusion 
  - value fall inside the range?
- Enumeration
  — traversable collection of items.

### Creating a range
- `Range#new(arg_1, arg_100, optional_arg)`
  - default is an inclusive range
  - optional_arg = true makes it exclusive

- literal syntax:
  - `..` - inclusive
  - `...` - exclusive

### Range-inclusion logic
  -`.begin`
    - starting point

  -`.end`
    - ending point

  - `.exclude_end?`
    - true for `...` range

  - `cover?` and
    - argument to the method is greater than or equal to start point
    - less than its end point (or equal to it, for an inclusive range)
    -  fails because the item being tested for inclusion isn’t comparable
  - `include?` (aliased as `member?`).
    - testing inclusion of a value in a range
    -  treats the range as a kind of crypto-array
```rb
>> r = 1..10 ### => 1..10
>> r.begin ### => 1
>> r.end => 10 ### >> r.exclude_end? ### => false

>> r = "a".."z" ### => "a".."z"
>> r.cover?("a") ### => true # true: "a" >= "a" and "a" <= "z"
>> r.cover?("abc") ### => true # true: "abc" >= "a" and "abc" <= "z"
>> r.cover?("A") ### => false # false: "A" < "a"

>> r.include?("a") ### => true
>> r.include?("abc") ### => false

>> r = 1.0..2.0 ### => 1.0..2.0
>> r.include?(1.5) ### => true
```
## Sets
- standard library
- set is a unique collection of objects. 
- The objects can be anything—strings, integers, arrays, other sets
-  sets use a hash to enforce the uniqueness 
- no literal set constructor
  - sets are part of the standard library, not the core,
  - the core syntax of the language is already in place before the set library gets loaded.
### Set creation
- no literal set constructor
- `Set.new`
  - empty or collection object(responds to `each`/`each_entry`)


```rb
>> names = ["Dav", "Yuki", "Chad", "Amy"]
=> ["Dav", "Yuki", "Chad", "Amy"]
>> name_set = Set.new(names) 
>> name_upcase_set = Set.new(names) {|name| name.upcase }
=> #<Set: {"DAV", "YUKI", "CHAD", "AMY"}>
```
### Manipulating set elements
#### ADDING/REMOVING ONE OBJECT TO/FROM A SET
- `<<`, `add` operator/method:
  - add single  element
  - adding element already in the set nothing happens:
- `add?`
  - it returns nil if set is unchanged
- `.delete`
  - removes single element
  - object that isn’t in the set doesn’t raise an error


```rb

tri_state = Set.new(["Jersey", "York"]) ### => #<Set: {"Jersey", "York"}>
tri_state << "Con" ### => #<Set: {"Jersey", "York", "Conn"}>
tri_state.add?("Penn") ### => nil

tri_state << "Conn" ### => #<Set: {"Jersey", "York", "Conn"}>
tri_state << "Penn" ### => #<Set: {"Jersey", "York", "Conn", "Penn"}>
tri_state.delete("Connecticut") ### => #<Set: {"Jersey", "York", "Penn"}>

```

### SET INTERSECTION, UNION, AND DIFFERENCE

* `intersection`, aliased as `&` 
* `union`, aliased as `+` and `|` 
* `difference`, aliased as `-`
* `exclusive-or` aliased as `^`

```rb
large = Set.new([1, 3, 5, 7]) ### => #<Set: {1, 2 , 3}>
small = Set.new([1, 2, 3 ,4]) ### => #<Set: {1, 2 , 3}>

# intersection 
large & small = ### => #<Set: {1, 3}>

# union 
large | small = ### => #<Set: {1, 2, 3, 4, 5, 7}>
large + small = ### => #<Set: {1, 2, 3, 4, 5, 7}>

#difference
large - small = ### => #<Set: {5, 7}>

# exclusive-or
large ^ small = ### => #<Set: {2, 4, 5, 7}>

```
- `.subset?`
  - subset/superset relationships
- `.supersets?`
  - subset/superset relationships
-  `proper_subset` 
  - a subset that’s smaller than the parent set(not equal).
- `.proper_superset`
  - a superset that’s larger than the parent set(not equal).
### MERGING
- `merge`
  - alters permanently
```rb
>> tri_state = Set.new(["Connecticut", "New Jersey"])
=> #<Set: {"Connecticut", "New Jersey"}>
>> tri_state.merge(["New York"])
=> #<Set: {"Connecticut", "New Jersey", "New York"}>

>> s = Set.new([1,2,3])
=> #<Set: {1, 2, 3}>
>> s.merge({ "New Jersey" => "NJ", "Maine" => "ME" })
=> #<Set: {1, 2, 3, ["New Jersey", "NJ"], ["Maine", "ME"]}>

---------------------------------
- core Ruby class vs standard library