ticket = Object.new

def ticket.date
  "1903-01-02"
end

def ticket.venue
  "Town Hall"
end

def ticket.event
  "Author's reading"
end

def ticket.performer
  "Mark Twain"
end

def ticket.seat
  "Second Balcony, row J, seat 12"
end

def ticket.price
  5.50
end

def ticket.available?
  false
end

def ticket.call_with(request)
  if ticket.respond_to?(request)
    puts ticket.send(request)
  else
    puts "No such information available"
  end
end

puts "This ticket is for: #{ticket.event}, at #{ticket.venue}.\n" +
"The performer is #{ticket.performer}.\n" +
"The seat is #{ticket.seat}, " +
"and it costs $#{"%.2f." % ticket.price}"
