class TicketComparer
  def self.compare(ticket1, ticket2, ticket3)
    case ticket1
    when ticket2
      puts "Same date as ticket2"
    when ticket3
      puts "Same date as ticket3"
    else
      puts "No maches"
    end
  end
end