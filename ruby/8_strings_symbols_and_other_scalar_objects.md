#  8_strings_symbols_and_other_scalar_objects

**Scalar:**
- objects that represent single values

**Vector:**
- collection or container objects that hold multiple values

## String
- notation: enclosed in quotation marks: `""` OR `''`
-  string interpolation work only with double quoted.
- behave differently with respect to the need to escape certain characters
  - escape sequences are interpreted in double quotes. In single quotes, only \\ (backslash backslash) and \' (backslash quote) are taken as special characters.
```rb
puts "Backslashes (\\) have to be escaped in double quotes."
puts 'You can just type \ once in a single quoted string.'
puts "But whichever type of quotation mark you use..."
puts "...you have to escape its quotation symbol, such as \"."
puts 'That applies to \' in single-quoted strings too.'
puts 'Backslash-n just looks like \n between single quotes.'
puts "But it means newline\nin a double-quoted string."
puts 'Same with \t, which comes out as \t with single quotes...'
puts "...but inserts a tab character:\tinside double quotes."
puts "You can escape the backslash to get \\n and \\t with double quotes."
```

### OTHER QUOTING MECHANISMS
- %char{text}
- Curly braces are by far the most common delimiter
  - delimiter can be just about anything you want as long as the opening delimiter matches the closing one
    - pair of braces (curly, curved, angular, or square)
    - two of the same non-alpha numeric character
    ```rb
      %q-A string-
      %Q/Another string/
      %[Yet another string]
    ```
  - the only character requires escaping is the ending delimiter 
- `%q{}`
  -  produces a single- quoted string
- `%Q{}` & `%{}` (percent sign and delimiter), 
  -a double-quoted string

### "HERE" DOCUMENTS
- multiline string, it’s physically present __"here"__ in the program file
- <<EOM means the text that follows, up to but not including the next occurrence of "EOM."
- The delimiter can be any string; EOM (end of message) is a common choice.
- `SQL` is also common because SQL queries can get lengthy

```rb
query = <<SQL
SELECT count (DISTINCT users.id)
FROM users
WHERE users.first_name='Joe';
SQL
```

-  Delimiter by itself must be flush left, and it must be the only thing on the line where it occurs
- can switch off the flush-left requirement by putting a hyphen before the << operator hyphen heredoc <<-
- squiggly heredoc," <<~, which strips leading whitespace from your output.
```rb
<<-EOM
      Welcome to the world of Ruby!
      We're happy you're here!
EOM
# => "      Welcome to the world of Ruby!\n      We're happy you're here!\n"

<<~EOM
      Welcome to the world of Ruby!
      We're happy you're here!
EOM
# => "Welcome to the world of Ruby!\nWe're happy you're here!\n
```

- By default, heredocs are read in as double-quoted strings; can include string interpolation and use of escape characters like \n and \t.
- For a single- quoted heredoc, put the closing delimiter in single quotes when you start the document.
```rb
text = <<-'EOM'
Single-quoted!
Note the literal \n.
And the literal #{2+2}
EOM

a = <<EOM.to_i * 10
5
EOM
puts a ### Output:50

array = [1,2,3, <<EOM, 4]
1+1
EOM
### Output: [1, 2, 3, "1+1\n", 4]
```
- you can use the <<EOM notation as a method argument
```rb

do_something_with_args(a, b, <<EOM)
http://some_very_long_url_or_other_text_best_put_on_its_own_line
EOM
```

### Basic string manipulation

### GETTING AND SETTING SUBSTRINGS

- **[ ], slice**
-The range can use negative numbers,
 - count from the end of the string backward, but the second index must be closer to end of string
```rb
string = "Ruby is a cool language."
string[5]       ### => "i"
string[-12]     ### => "o"
string[5,10]    ### => "is a cool "
#========================= range =========================
string[7...14]  ### => " a cool"
>> string[-12..-3] ###=> "ol languag"

#========================= explicit substring search =========================
string["cool lang"] ### => "cool lang"
string["very cool lang"] ### => nil
#========================= search for a pattern match ========================= 
```
we also have the mutating counterparts:
- **`[]=`, &  `slice!`**
- `IndexError` is raised. for out of index values

### COMBINING STRINGS
- using `+` 
  - doesn't change the caller & we get new strings
- using `<<`
  - change the caller
- VIA INTERPOLATION
  - `"#{}"`
  - any interpolated code 
  - interpolates by calling `to_s` on the object to which the interpolation code evaluates
```rb
str = "Hi "
str + "there." ### => "Hi there."
str << "there" ### => "Hi there"
"#{str}!!!"  ### => "Hi there!!!"
```
### Querying strings
- `.include?`
- `.start_with?` and `.end_with?`
  - also supports regular expressions:
- `.empty?`
- `.size` and `.length`
- `.count`
  - how many times a given letter or set of letters occurs in a string
  - range of letters there are
  - can provide a written-out set of characters
  - count the number of characters that don’t match the ones you specify—put a ^ (caret)
  - even provide more than one argument:
- `.index`, `.rindex`
```rb

#==================== `.include?` ====================
>> string.include?("Ruby") ### => true
>> string.include?("English") ### => false

#==================== `.start_with?` and `.end_with?` ====================
>> string.start_with?("Ruby") ### => true
>> string.end_with?("!!!") ### => false
>> string.start_with?(/[A-Z]/) ### => true

#==================== `.empty?` ====================
>> string.empty? ### => false
>> "".empty? ### => tr

#==================== `.size` and `.length` ====================
>> string.size ### => 24

#==================== `.count` ====================
>> string.count("a") ### => 3
>> string.count("g-m") ### => 5
>> string.count("A-Z") ### => 1
>> string.count("aey. ") ### => 1
>> string.count("^aey. ") ### => 14

#==================== .index & .rindex` ==================== 
>> string.index("cool") ### => 10
>> string.index("l") ### => 13
>> string.rindex("l") ### => 15
```

- `.ord`
  - One-character strings can tell you their ordinal code
  - longer string, you get the code for the first character:

- `.chr`
  -  method on integer
  - chr equivalent causes a fatal error.
```rb
"a".ord ### => 97
"abc".ord ### => 97
97.chr ### => "a"
```

### String comparison and ordering
- String class mixes in the Comparable module 
- based on char code
- spaceship operator returns 
  - -1 if the right object is greater
  - 1 if the left object is greater
  - 0 if the two objects are equal.

- `String#eql?`
- `String#equal?`
- `==`

```rb
#====================== Comparable ======================

"a" <=> "b" ### => -1
"b" > "a" ### => true
"a" > "A" ### => true
"." > "," ### => true
#======================  equals ======================

"a" == "a" ### => true
"a"eql?("a") ### => true
"a".equal?("a") ### => false
"a".equal?(100) ### => false
```

### String transformation

#### CASE TRANSFORMATIONS
- `.upcase`
- `.downcase`
- `.swapcase`
- `.capitalize`
```rb
string = "David A. Black"### => "David A. Black"
string.upcase### => "DAVID A. BLACK"
string.downcase### => "david a. black"
string.swapcase### => "dAVID a. bLACK"
string = "david"### => "david"
string.capitalize### => "David"
```

#### FORMATTING TRANSFORMATIONS
- `rjust`, `ljust` & `center`
  - adds padding
  - padding with blank spaces if no 2nd param
- `strip`, `lstrip`, and `rstrip`
  - stripping whitespace 
  - has bang! counterparts
```rb
>> string = "David A. Black" ### => "David A. Black"
>> string.rjust(25) ### => "           David A. Black"
>> string.ljust(25) ### => "David A. Black           "
>> string.rjust(25,'.') ### => "...........David A. Black"
>> string.rjust(25,'><') ### => "><><><><><>David A. Black"
>> "The middle".center(20, "*") ### => "*****The middle*****"
```
#### CONTENT TRANSFORMATIONS
- `chop`
  - chop removes a character unconditionally
- `chomp`
  - chomp removes a target substring
- `clear`
  - empties a string
  - permanently changes the string
- `replace`
  -  swap out all your characters with param
  - permanently changes the string
- `delete`
  - target certain characters for removal
  - follows same rules as count
- `crypt`
  - Data Encryption Standard (DES) 
  - similar to the Unix crypt(3)
  - single argument to crypt is a two-character salt string:
- `succ`
  - Incrementation continues, odometer-style
```rb
#=========================== chop ===========================
"David A. Black".chop ### => "David A. Blac"
#=========================== chomp ===========================
"David A. Black\n".chomp ### => "David A. Black"
"David A. Black".chomp('ck') ### => "David A. Bla"
#=========================== clear ===========================
string = "David A. Black" ### => "David A. Black"
string.clear ### => ""
string ### => ""
#=========================== replace ===========================
string = "(to be named later)" ### => "(to be named later)"
string.replace("David A. Black") ### => "David A. Black"
#=========================== delete ===========================
"David A. Black".delete("abc") ### => "Dvid A. Blk"
"David A. Black".delete("^abc") ### => "aac"
"David A. Black".delete("a-e","^c") ### => "Dvi A. Blck"
#=========================== crypt ===========================
"David A. Black".crypt("34") ### => "347OEY.7YRmio"
#=========================== succ ===========================
"a".succ ### => "b"
"azz".succ ### => "baa"
```

### String conversions

- `to_i`
  - parementer in 2–36
  - interpreted as representing a number in the base 
- `oct` and `hex`
  - Base 8 and base 16 are considered special cases

- `to_f` 
  - (to float), 
- `to_s` and  `to_str` 
  - (to string; it returns its receiver), 
- `to_c` and  `to_r` 
  - (to complex and rational numbers, respectively), and 
- `to_sym` or `intern`,
  - Symbol object
```rb
"1.2345".to_f ### => 1.2345
"Hello".to_str ### => "Hello"
"-4e-2i".to_c ### => (0-0.04i)
"4.55".to_r ### => (91/20)
"abcde".to_sym ### => :abcde
"1.2345and some words".to_f ### => 1.2345
"just some words".to_i ### => 0
```

### String encoding: a brief introduction
- `puts __ENCODING__  ### => UTF-8`
- file- less Ruby run takes its encoding from the current locale setting.
- `LANG=en_US.iso885915 ruby -e 'puts __ENCODING__' ### => US-ASCII`
- magic comment on top `# encoding: encoding`
  - You may use the word coding
- individual strings
  - force_encoding
  - bypasses the table of "permitted" encodings 
  - encodes the bytes of the string with the encoding you specify, unconditionally.
- represent arbitrary characters in a string using either the `\x` escape sequence with a two-digit hexadecimal number representing a byte, or the `\u` escape sequence with a UTF-8 code; the corresponding character will be inserted.
  - encoding switches to UTF-8.
  ```rb
  str = "Test string"  ### => "Test string"
  str.encoding  ### => #<Encoding:UTF-8>
  str.encode!("US-ASCII")  ### => "Test string"
  str.encoding  ### => #<Encoding:US-ASCII>
  ```

## Symbols
- the leading colon
- `string.intern` => `string.to_sym`
- Symbols are immutable
- Symbols are unique
  - symbol :xyz notation always represents the same object
  ```rb
    >> :xyz.object_id ### => 160488
    >> :xyz.object_id ### => 160488
    ```
- no Symbol#new(constructor)
- When you assign a value to a variable or constant, or create a class or write a
method, the identifier you choose goes into Ruby’s internal symbol table `Symbol.all_symbols`
  - any newly created symbols itself will be added to Symbol#all_symbols
- method arguments and hash keys.

### method arguments
- attr_* method family:
- send method, 
-  most methods that take symbols can also take strings.

### as hash keys
- no constraints on hash keys. can use an array, class, another hash, a string, or any object you like as a hash key. 
- Ruby can process symbols faster
```rb
joe_hash = { name: "Joe", age: 36 } ### => {:name=>"Joe", :age=>36}
```
### Strings and symbols in comparison
- instance methods that symbols share with strings
- No bang versions
- indexing into a symbol returns a substring
-  symbols are more like integers than strings
- immediacy: a variable to which a symbol is bound gives the actual symbol value, not a reference
```rb
sym = :david ### => :david
sym.upcase ### => :DAVID
sym.succ ### => :davie
sym[2] ### => "v"
```

## Numerical objects
```rb 
m = n.round
if x.zero?
97.chr
```

- classic Float and Integer inherit. Numeric i
- divide integers, the result is always an integer
- you have to feed floating-point numbers to get float output
- Integers beginning with 0 are interpreted as octal (
- Hexadecimal integers has a leading `0x`
-  supply the base you want to convert from as an argument to `to_i `
- most of the arithmetic operators are methods

- if you define, a method called `+` in a class of your own, you can use the operator’s syntactic sugar. 

## Times and dates
- classes: Time, Date, and DateTime.
```rb
require 'date'
require 'time'
```
### Instantiating date/time objects
#### CREATING DATE OBJECTS
- `Date.today`, 
- `Date.civil`, `Date.new(:year, :month, :day)`
  - month and day (or just day) default to 1
  -  year defaults to 4712
- `Date.parse`
  - expects a string representing a date:
  - expands the century one/two-digit number. 
    - is 69 or greater, then the offset is 1900; 
    - between 0 and 68, the offset is 2000
```rb
Date.today  ### => #<Date: 2018-12-15 ((2458134j,0s,0n),+0s,2299161j)
puts Date.today  ### 2018-12-15

puts Date.new(1959,2,1)  ### 1959-02-01

puts Date.parse("2003/6/9")  ### 2003-06-09

puts Date.parse("03/6/9")   ### 2003-06-09
puts Date.parse("33/6/9")   ### 2033-06-09
puts Date.parse("77/6/9")   ### 1977-06-09

puts Date.parse("November 2 2013")   ### 2013-11-02
puts Date.parse("Nov 2 2013")   ### 2013-11-02
puts Date.parse("2 Nov 2013")   ### 2013-11-02
puts Date.parse("2013/11/2")   ### 2013-11-02

```

- `jd` and `commercial`,
- scan a string against a format specification, generating a Date object, with `strptime`

#### CREATING TIME OBJECTS

Time.new (or Time.now)
  - creates a time object representing the current time 
Time.at(seconds)
  - gives you a time object for the number of seconds since the epoch (midnight on January 1, 1970, GMT) represented by the seconds argument
Time.mktime (or Time.local)
  - expects year, month, day, hour, minute, and second arguments. 
  - defaults (1 for month and day; 0 for hour, minute, and second)
- Time.parse,
  - you have to load the time library
  -  like Date.parse

```rb
Time.new   ### => 2018-12-15 18:55:47 -0500
Time.at(100000000)   ### => 1973-03-03 04:46:40 -0500
Time.mktime(2007,10,3,14,3,6)   ### => 2007-10-03 14:03:06 -0400
require 'time'   ### => true
Time.parse("March 22, 1985, 10:35 PM")   ### => 1985-03-22 22:35:00 -0500
```

#### CREATING DATE/TIME OBJECTS
- DateTime is a subclass of Date
-  its constructors are a little different
  -  `new` (also available as `civil`), `now`, and `parse`:
- also has `jd` (Julian date), `commercial`, and `strptime`
```rb
puts DateTime.new(2009, 1, 2, 3, 4, 5)   ### 2009-01-02T03:04:05+00:00
puts DateTime.now   ### 2018-12-15T19:02:29-05:00
puts DateTime.parse("October 23, 1973, 10:34 AM")   ### 1973-10-23T10:34:00+00:00
```

### Date/time query methods
- Time objects can be queried as to their `year`, `month`, `day`, `hour`, `minute`, and `second`,
  - as can date/time objects.
  - date/time objects have a `second` & `sec`. Time objects have only `sec`.
- Date objects can be queried as to their year, month, and day:
- particular day of the week:
  - `.sunday?`, `.saturday?`, `.friday?`
- `leap?`, available to Date and DateTime
- `dst?` (daylight saving time), available to `Time` only.

### Date/time formatting methods

**DATE**
- `%Y`       - Year (4 digits)
- `%y`       - Year (last 2 digits)
- `%b`, `%B` - Short month, full month
- `%m`       - Month (number)
- `%d`       - Day of month (left-padded with zeros) 
- `%e`       - Day of month (left-padded with blanks)
- `%a`, `%A` - Short day name, full day name

**TIME**
- `%H`, `%I` - Hour (24-hour clock), hour (12-hour clock)
- `%M`       - Minute
- `%S`       - Second
- `%c`       - Equivalent to "%a %b %d %H:%M:%S %Y"
- `%x`       - Equivalent to "%m/%d/%y"

- `%c` and `%x` specifiers, which involve convenience combinations of other specifiers, may differ from one locale to another
```rb
t = Time.now
t.strftime("Today is %x")
```
RFC 2822 (email) compliance and the 
HTTP format specified in RFC 2616:
```rb
>> Date.today.rfc2822 ### => "Sat, 15 Dec 2018 00:00:00 +0000"
>> DateTime.now.httpdate ### => "Sun, 16 Dec 2018 00:17:53 GMT"
```


### Date/time conversion methods
Time has `to_date` and `to_datetime`,
Date has `to_time` and `to_datetime`,
DateTime has `to_time` and `to_date`
  - the missing fields are set to 0—essentially, midnight, because date has no time

#### DATE/TIME ARITHMETIC
- Time objects let you add and subtract **seconds** 
- Date and date/time objects interpret `+` and `–` as **day-wise** operations,
- **month-wise** conversions with `<<` and `>>`:
- `next` (a.k.a. `succ`) method
- `next_unit` and `prev_unit`
```rb
t = Time.now  ### => 2018-12-15 19:19:39 -0500

#===================== add and subtract seconds  ============================
t - 20  ### => 2018-12-15 19:19:19 -0500
t + 20  ### => 2018-12-15 19:19:59 -0500

#===================== day-wise, month-wise operations, ============================
dt = DateTime.now  ### => #<DateTime: 2018-12-15T19:21:11-0500 ... >
puts dt + 100  ### 2019-03-25T19:21:11-05:00

puts dt >> 3  ### 2019-03-15T19:21:11-05:00
puts dt << 10  ### 2019-02-15T19:21:11-05:00

#===================== next, next_unit, prev_unit ============================
d = Date.today  ### => #<Date: 2018-12-15 ((2458134j,0s,0n),+0s,2299161j)>
puts d.next  ### 2018-12-16
puts d.next_year  ### 2019-12-16
puts d.next_month(3)  ### 2018-12-15
puts d.prev_day(10)  ### 2018-12-05\
```

- date and date/time objects allow you to iterate over a range
- using `upto`
```rb
d = Date.today  ### => #<Date: 2018-12-15 ((2458134j,0s,0n),+0s,2299161j)>
next_week = d + 4  ### => #<Date: 2018-12-22 ((2458141j,0s,0n),+0s,2299161j)>
d.upto(next_week) {|date| puts "#{date} is a #{date.strftime("%A")}" }
### 2018-12-15 is a Saturday
### 2018-12-16 is a Sunday
### 2018-12-17 is a Monday
### 2018-12-18 is a Tuesday
```