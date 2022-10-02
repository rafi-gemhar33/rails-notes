class Car
  @@makes = []
  @@cars = {}
  @@total_count = 0
  attr_reader :make
  
  class << self
    def add_make(make)
      unless @@makes.include?(make)
        @@makes << make
        @@cars[make] = 0
      end
    end

    def total_count
      @@total_count
    end
  end

  def initialize(make)
    if @@makes.include?(make)
      @make = make
      puts "Creating a new #{make}!"
      @@cars[make] += 1
      @@total_count += 1
    else
      raise "No such make: #{make}."
    end
  end

  def make_mates
    @@cars[self.make]
  end
end


# Car.add_make("Honda")
# Car.add_make("Ford")
# h = Car.new("Honda")
# f = Car.new("Ford")
# h2 = Car.new("Honda")

# puts "Counting cars of same make as h2..."
# puts "There are #{h2.make_mates}."


# puts "Counting total cars..."
# puts "There are #{Car.total_count}."

# x = Car.new("Brand X")


#################################################

class Car1
  attr_reader :make
  
  class << self
    def add_make(make)
      unless makes.include?(make)
        makes << make
        cars[make] = 0
      end
    end

    def makes
      @makes ||= []
    end

    def cars
      @cars ||= {}
    end

    def total_count
      @total_count ||= 0
    end

    def total_count=(n)
      @total_count = n
    end
  end

  def initialize(make)
    if self.class.makes.include?(make)
      @make = make
      puts "Creating a new #{make}!"
      self.class.cars[make] += 1
      self.class.total_count += 1
    else
      raise "No such make: #{make}."
    end
  end

  def make_mates
    self.class.cars[self.make]
  end
end


class Hybrid1 < Car1
end



Car1.add_make("Honda")
Car1.add_make("Ford")
h = Car1.new("Honda")
f = Car1.new("Ford")
h2 = Car1.new("Honda")

puts "Counting cars of same make as h2..."
puts "There are #{h2.make_mates}."


puts "Counting total cars..."
puts "There are #{Car.total_count}."