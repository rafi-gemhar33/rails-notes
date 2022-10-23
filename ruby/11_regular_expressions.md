# Regular expressions and regexp-based string operations

## What are regular expressions?
- it specifies a pattern of charac- ters, a pattern that may or may not correctly predict
- Regular expressions in Ruby are instances of the `Regexp` class.
- parsing log files, testing keyboard input for valid- ity, and isolating substrings—operations, in other words
- representations of patterns.

## Writing regular expressions
### Seeing patterns
### literal regular expressions
- `//`
- `%r{}`

- `match` method or 
  - return MatchData or nil
- `match?`
- pattern-matching operator, `=~ `
  - returns the numerical index 

| Symbol  |   Meaning                                                                         |
|---------|-----------------------------------------------------------------------------------|
| **=~**  | Determines if a match exists                                                      |
| **.**   | Matches any character except \n                                                   |
| **\\**  | Escape character; tells Ruby to treat the next character as a literal             |
| **[ ]** | Surrounds a character class; matches either character between [ and ]             |
| **^**   | 1. Negates a character or character class; matches anything except what follows ^ |
|         | 2. Matches the expression at the start of a line                                  |
| **\d**  | Matches any digit                                                                 |
| **\D**  | Matches anything except a digit                                                   |
| **\w**  | Matches any digit, alphabetical character, or underscore                          |
| **\W**  | Matches anything except a digit, alphabetical character, or underscore            |
| **\s**  | Matches any whitespace character (space, tab, newline)                            |
| **\S**  | Matches anything except a whitespace character (space, tab, newline)              |
| **{ }** | Matches a character or character class a specific number of times                 |
| **$**   | Matches the expression at the end of a line                                       |
| **+**   | Matches one or more occurrences of the character or character class               |
| **\***  | Matches zero or more occurrences of the character or character class              |
-----------------------------------------------------------------------------------------------


## Building a pattern in a regular expression 355

- Literal characters, meaning "match this character"
- The dot wildcard character (.), meaning "match any character" (except \n, the newline character)
- Character classes, meaning "match one of these characters"

### Literal characters in patterns
- matches itself 
- `/a/`
- escapespecial chars using `\`  =>  `/\?/`
  - `^`, `$`, `?`
  - `.`, `/`, `\`
  - `[`, `]`, `{`, `}`
  - `(`, `)`, `+`, `*`
-  `%r{}` syntax, you don’t need to escape the `/`
```rb
/\/home\/jleo3/
%r{/home/jleo3}
```

### The dot wildcard character (.)
- any character except a newline
```rb
/.ejected/
matches ### => "%ejected", "8ejected", "dejected", and "rejected"
/.ejected/.match?("%ejected") ### => true
```

### Character classes
- explicit list of characters placed inside the regexp in square brackets:
- partial or constrained wildcard
-  `/[dr]/`, its not matching `dr`; it’s going to match either `d` or `r`
- range of characters
  - `[a-z]`, `[a-fA-F0-9]`

-  negating a character class. rpefix with `^`
  - `%r{[^A-Fa-f0-9]}`
```rb
%r{[DdEe]ejected}  ## => match either d or r, followed by ejected.
```

#### SPECIAL ESCAPE SEQUENCES
- `[0-9]` -> `\d`
- `[^0-9]` -> `\D`
- `\w` matches any digit, alphabetical character, or underscore (_).
- `\W` matches any character other than an alphanumeric character or underscore, 
- `\s` matches any whitespace character (space, tab, newline).
- `\S` matches any non-whitespace character.

## Matching, substring captures, and MatchData
- parentheses to specify captures.

- `MatchData` object that gives us access to the submatches.
- Ruby automatically populates a series of variables for us, which also give us access to those submatches.
  - populates are global variables, and their names are based on numbers: `$1`, `$2`, and 
  - `$0` for something else: it contains the name of the Ruby program file from which the current program or script was initially started up

```rb
/([A-Za-z]+),[A-Za-z]+,(Mrs?\.)/.match("Peel,Emma,Mrs.,talented amateur") 
### => #<MatchData "Peel,Emma,Mrs." 1:"Peel" 2:"Mrs.">
puts "Dear #{$2} #{$1}," ### => Dear Mrs. Peel,
```
### Match success and failure
- doesn’t match, the result is always `nil`:
- `.captures` 
  - returns all the captured substrings in a single array.

```rb
%r{a}.match("b") ### => nil

string = "My phone number is (123) 555-1234."
phone_re = %r{\((\d{3})\)\s+(\d{3})-(\d{4})}
m = phone_re.match(string)

puts m.string ### My phone number is (123) 555-1234.
puts m[0] ### (123) 555-1234
puts "The three captures: "
puts m[1] ### (123)
puts m[2] ### 555
puts m[3] ### 1234

m[1] == m.captures
```
### Two ways of getting the captures
-  directly indexing the object, array-style:
- `.captures` 

- counting parentheses from the left
- For each opening parenthesis, find its counterpart on the right. 
  - Everything inside that pair will be capture number _n_, for whatever _n_ you’ve gotten up to
```rb
/((a)((b)c))/.match("abc") ### #<MatchData "abc" 1:"abc" 2:"a" 3:"bc" 4:"b">
```

#### NAMED CAPTURES
- `first`, `middle`, and `last` are providing named captures
- `MatchData` comes has `named_captures`
- `?` character is a quantifier
```rb
re = %r{(?<first>\w+)\s+((?<middle>\w\.)\s+)(?<last>\w+)}
m = re.match("David A. Black") ### => #<MatchData "David A. Black" first:"David" middle:"A." last:"Black">
m.named_captures ### => {"first"=>"David", "middle"=>"A.", "last"=>"Black"}


re = /(?<first>\w{3})\s+((?<last>\w{3}),?\s?)(?<suffix>\w+\.?)?)/ ### => /(?<first>\w{3})\s+((?<last>\w{3}),?\s?)(?<suffix>\w+\.?)?)/
re.match "Joe Leo III"   ###=> #<MatchData "Joe Leo III", first:"Joe" last:"Leo" suffix:"III"> 
m = re.match "Joe Leo, Jr."   ###=> #<MatchData "Joe Leo, Jr.", first:"Joe" last:"Leo" suffix:"Jr.">
m.named_captures   ###=> {"first"=>"Joe", "last"=>"Leo", "suffix"=>"Jr."}
m = re.match "Joe Leo"   ###=> #<MatchData "Joe Leo", first:"Joe" last:"Leo" suffix:nil>
m[:suffix]   ###=> nil
```

### Other MatchData information
- `pre_match`
- `post_match` 

- `begin`
- `end` 
  - These methods tell you where the various parenthetical captures, if any, begin and end.
  - you provide an argument, to get the information for capture _n_, 
```rb
string = "My phone number is (123) 555-1234."
phone_re = %r{\((\d{3})\)\s+(\d{3})-(\d{4})}
m = phone_re.match(string)

puts m.pre_match   ###  My phone number is
puts m.post_match   ### .
puts m.begin(2)   ### 25
puts m.end(3)   ### 33
```
- using either match or =~
- Ruby sets the global variable `$~` to a MatchData object representing the match.
  - On an unsuccessful match, `$~` gets set to `nil`.


## quantifiers, anchors, and modifiers.
- Quantifiers let you specify how many times in a row you want something to match
- Anchors let you stipulate that the match occur at a certain structural point in a string 
  - (beginning of string, end of line, at a word boundary, and so on)
- Modifiers are like switches you can flip to change the behavior of the regexp engine; 
  - by making it case insensitive
  -  altering how it handles whitespace.

### Constraining matches with quantifiers
- what you want but also how many: 
  - exactly one of a particular character,
  - 5–10 repetitions of a subpattern

- either on a single character (character class) 
- on a parenthetical group

#### ZERO OR ONE
- `?` -  indicate zero or one of any of a number of characters

#### ZERO OR MORE
- `*` zero-or-more quantifier—the asterisk

#### ONE OR MORE
- `+` one-or-more quantifier—the asterisk


```rb
m_r = %r{Mrs?\.?}
["Mr", "Mrs", "Mr.", "Mrs."].each { |tag| m_r.match?(tag)}

t_r = %r{<\s*/\s*poem\s*>}
["</poem>", "< /poem>", "</    poem>", "</poem\n>"].each { |tag| t_r.match?(tag)}

/\d+/.match?("Digits-R-Us 2345") ### => true
```
### Greedy (and non-greedy) quantifiers
- The **`*` (zero-or-more) **and **`+` (one-or-more)** quantifiers are greedy

- + as well as * into non-greedy quantifiers by putting a question mark

- greediness always subordinates itself to ensuring a successful match
  - if incase of absolute match
```rb
string = "abc!def!ghi!"### => "abc!def!ghi!"
/.+!/.match(string)[0]### => "abc!def!ghi!"

/.+?!/.match(string)[0]### => "abc!"### 
/(\d+)/.match("Digits-R-Us 2345")[1] ### => "2345"
/(\d+?)/.match("Digits-R-Us 2345")[1]### => "2"
/\d+5/.match("Digits-R-Us 2345") ### => #<MatchData "2345">
/(\d+)(5)/.match("Digits-R-Us 2345") ### => #<MatchData "2345" 1:"234" 2:"5">
```

#### SPECIFIC NUMBERS OF REPETITIONS
- put the number in curly braces `{}`
- range inside the braces: `/\d{1,10}/`
  - {3,} => three or more
- Fatal error if  range is impossible;

- an atom is one part of your pattern.
  - Atoms include subpatterns wrapped in parentheses, character classes, and individual characters. 
  -You can specify that a repetition to atoms

```rb
/\d{3}-\d{4}/ ### exactly three digits, a hyphen, and then four digits
```
#### THE LIMITATION ON PARENTHESES
- parathesis captures should be stashed in the first capture slot
  - it matches one character n times in case of `/(){n}/`
```rb
# matching one character five times
/([A-Z]){5}/.match("David BLACK")  ### => #<MatchData "BLACK" 1:"K">

# matching five characters one time.
/([A-Z]{5})/.match("David BLACK")  ### => #<MatchData "BLACK" 1:"BLACK">
```

### Regular expression anchors and assertions
- expresses a constraint: 
  - a condition that must be met before the matching of characters is allowed to proceed

- beginning of line (`^`)
- end of line (`$`)

```rb
#  lines that did not start with a hash mark (#)
comment_regexp = /^\s*#/ ### => /^\s*#/
comment_regexp.match("  # Pure comment!") ### => #<MatchData "  #">
comment_regexp.match("  x = 1  # Code plus comment!") ### => nil
```


|Notation | Description            | Example             | Sample matching string                       |
|---------|----------------------- |---------------------|----------------------------------------------|
|**^**  | Beginning of line        | /^\s*#/             | " # A Ruby comment line with leading spaces" |
|**$**  | End of line              | /\.$/ |             | "one\ntwo\nthree.\nfour"                     |
|**\A** | Beginning of str         | /\AFour score/      | "Four score"                                 |
|**\z** | End of str               | /from the earth.\z/ | "from the earth."                            |
|**\Z** | End of str, excl.        | /from the earth.\Z/ | "from the earth.\n"                          |
|       | final `\n` char, if any  |                     |                                              |
|**\b** | Word boundary            | /\b\w+\b/           | "!!!word***" (matches "word")                |
---------------------------------------------------------------------------------------------------------



#### LOOKAHEAD ASSERTIONS
-  `(?=...)`   a zero-width, positive lookahead assertion
- negative lookaheads; they use `(?!...) `
```rb
str = "123 456. 789"
m = /\d+(?=\.)/.match(str)
m[0] = 456
```

#### LOOKBEHIND ASSERTIONS

- `?<=` - positive
- `?<!` - negative
```rb
re = /(?<=David )BLACK/
re = /(?<!David )BLACK/
```
- `?:`
Unlike a zero-width assertion, a `(?:)` group does consume characters. It just doesn’t save them as a capture.


#### CONDITIONAL MATCHES


```rb
re = /(a)?(?(1)b|c)/  ### => /(a)?(?(1)b|c)/
re.match("ab")  ### => #<MatchData "ab" 1:"a">
re.match("b")  ### => nil
re.match("c")  ### => #<MatchData "c" 1:nil>

################################################################
`/(?<first>a)?(?(<first>)b|c)/`
################################################################

# If A is true, then evaluate the expression X, else evaluate Y
/(?(A)X|Y)/

# If A is true, then X
/(?(A)X)/

# If A is false, then Y
/(?(A)|Y)/
```


### Modifiers
- modifier is a letter placed after the final, closing forward slash of the regex literal:
- `i` => case insensitive
- `m` (multiline) any character, including newline.
- `x` =>  treats whitespace. Instead of including it literally in the pattern, 
  - ignores it unless it’s escaped with a backslash.
  - best saved for cases where you want to break the regexp out onto multiple lines
  - for the sake of adding comments
```rb
/abc/i

str = "This (including\nwhat's in parens\n) takes up three lines."
m = /\(.*?\)/m.match(str)

/\((\d{3})\)\s(\d{3})-(\d{4})/

/
  \((\d{3})\)  # 3 digits inside literal parens (area code)
    \s         # One space character
  (\d{3})      # 3 digits (exchange)
    -         # Hyphen
  (\d{4})      # 4 digits (second part of number
/x

##### /(\$[,0-9]+)/g
```
## Converting strings and regular expressions to each other
- `/abc/` is not `"abc"`
- it matches not only "abc" but any string with the substring "abc" 
  - somewhere inside it (like "Now I know my abcs.").
### String-to-regexp idioms
- string (or string-style) interpolation inside a regexp.
- When string interpolating contains regexp special characters
- instantiate a regexp from a string by passing the string to Regexp.new:
  -` Regexp.escape("a.c")`
```rb
str = "def" ### => "def"
/abc#{str}/ ### => /abcdef/

str = "a.c" ### => "a.c"
re = /#{Regexp.escape(str)}/ ### => /a\.c/

Regexp.new('(.*)\s+Black') ### => /(.*)\s+Black/
```
### Going from a regular expression to a string 377
```rb
puts /abc/ ### => (?-mix:abc)
puts /abc/i ### => (?i-mx:abc)
/abc/.inspect ### => "/abc/"
```

## Common methods that use regular expressions
### String#scan
- testing repeatedly for a match with the pattern you specify
- left to right
- parenthetical groupings in the regexp you give to scan, the operation returns an array of arrays
- can also take a code block
  - yielding depend on whether you’re using parenthetical captures
```rb
"testing 1 2 3 testing 4 5 6".scan(/\d/) ### => ["1", "2", "3", "4", "5", "6"]
str = "Leopold Auer was the teacher of Jascha Heifetz."
violinists = str.scan(/([A-Z]\w+)\s+([A-Z]\w+)/) ### => [["Leopold", "Auer"], ["Jascha", "Heifetz"]]

str.scan(/([A-Z]\w+)\s+([A-Z]\w+)/) do |fname, lname|
  puts "#{lname}'s first name was #{fname}."
end
```
### StringScanner
```rb
require 'strscan' ### => true
ss = StringScanner.new("Testing string scanning" ### => #<StringScanner 0/23 @ "Testi...">
ss.scan_until(/ing/) ### => "Testing"
ss.pos ### => 7
ss.peek(7) ### => " string"
ss.unscan ### => #<StringScanner 0/23 @ "Testi...">
ss.pos ### => 0
ss.skip(/Test/) ### => 4
ss.rest ### => "ing string scanning"
```
### String#split
- split can take either a regexp or a plain string as the sep- arator for the split operation.
-  second argument to split; this argument limits the number of items returned. In this example,

```rb
line = "first_name=david;last_name=black;country=usa"
record = line.split(/=|;/)
"a,b,c,d,e".split(/,/,3)  ### => ["a", "b", "c,d,e"]
```
### gsub/gsub!
```rb
# SINGLE SUBSTITUTIONS WITH SUB
 "typigraphical error".sub(/i/,"o") ### => "typographical error"
 "capitalize the first vowel".sub(/[aeiou]/) {|s| s.upcase } ### => "cApitalize the first vowel"

# GLOBAL SUBSTITUTIONS WITH GSUB
 "capitalize every word".gsub(/\b\w/) {|s| s.upcase } ### => "Capitalize Every Word"
USING THE CAPTURES IN A REPLACEMENT STRING
 "aDvid".sub(/([a-z])([A-Z])/, '\2\1') ### => "David"
 "double every word".gsub(/\b(\w+)/, '\1 \1') ### => "double double every every word word"
```
### Case equality and grep

Regexp#===: is used in 
  - case when 
  ```rb
  case answer
    when /^y/i
    /^y/i === answer
  ```
  - array grep
  - there’s no automatic conversion between numbers and strings
  ```rb
  ["USA", "UK", "France", "Germany"].grep(/[a-z]/)  ### => ["France", "Germany"]
  ["USA", "UK", "France", "Germany"].select {|c| /[a-z]/ === c }
  ```