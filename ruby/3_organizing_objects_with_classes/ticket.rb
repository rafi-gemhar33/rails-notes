class Ticket
  attr_reader :venue, :date
  attr_accessor :price

  VENUES = ["Convention Center", "Fairgrounds", "Town Hall"] #  Ticket::VENUES

  def initialize(venue, date)
    if VENUES.include?(venue)
      @venue = venue
    else
      raise ArgumentError, "Unknown venue #{venue}"
    end
    @date = date
  end
end

# class Ticket
#   def event
#     "Can't really be specified yet..."
#   end
# end

# ticket = Ticket.new
# puts ticket.event

###################################


# class Ticket
#   def initialize(venue,date)
#     @venue = venue
#     @date = date
#     @price = price
#   end

#   def venue
#     @venue
#   end

#   def date
#     @date
#   end

#   def price
#     @price
#   end
# end

#############################################

