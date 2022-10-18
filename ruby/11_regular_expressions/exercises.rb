# find the index of the first occurrence of a non-hex character in a string:

str = "ABC3934 is a hex number."
index = str =~ %r{[^a-fA-f0-9]}

str[0...index]

/((a)((b)c))/.match("abc")
#


re = %r{(?<first_name>\w{6})\s+(?<last_name>\w{4})\s+(?<initials>\w{1})} ### => /(?<first_name>\w{6})\s+(?<last_name>\w{4})\s+(?<initials>\w{1})/
re.match n ### => #<MatchData "Gemhar Rafi S" first_name:"Gemhar" last_name:"Rafi" initials:"S">


