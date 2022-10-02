
class C
  def self.x
    puts "Class method of class C"
    puts "self: #{self}"
  end
end

class C
  class << self
    def x
      # definition of x
      puts "Class method of class C"
      puts "self: #{self}"
    end 
    def y
      # definition of y
    end
  end
end

class D < C
end
# D.x ### Class method of class C
      ### self: D


class C
  def set_v
    # this @v belongs to instances of C
    @v = "I am an instance variable and I belong to any instance of C."
  end

  def show_var
    puts @v
  end
  def self.set_v 
    #  this @v belongs to Class C
    @v = "I am an instance variable and I belong to C."
  end

  class << self
    attr_accessor :v

    def show_var
      puts @v
    end
  end
end
# C.set_v
# C.show_var ### I am an instance variable and I belong to C.
# c = C.new
# c.set_v
# c.show_var ### I am an instance variable and I belong to any instance of C.


class C
  puts "Just inside class definition block. Here's self:"
  p self
  @v = "I am an instance variable at the top level of a class body."
  puts "And here's the instance variable @v, belonging to #{self}:"
  p @v
  def show_var
    puts "Inside an instance method definition block. Here's self:"
    p self
    puts "And here's the instance variable @v, belonging to #{self}:"
    p @v
  end
end

c = C.new
c.show_var

# Just inside class definition block. Here's self:
# C
# And here's the instance variable @v, belonging to C:
# "I am an instance variable at the top level of a class body."
# Inside an instance method definition block. Here's self:
# #<C:0x00007fbcd9977528>
# And here's the instance variable @v, belonging to #<C:0x00007fbcd9977528>:
# nil