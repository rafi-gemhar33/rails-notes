module M
  def M.m_method
    puts "********** M.m_method ********** "
    puts self.inspect
    puts self.class
    puts "**********"
  end

  def m_inst_method
    puts "********** m_inst_method ********** "
    puts self.inspect
    puts self.class
    puts "**********"
  end
end

class C
  extend M
  # include M
  def C.c_method
    puts "********** c_method **********"
    puts self.inspect
    puts self.class
    puts "**********"
  end

  def inst_method
    puts "********** inst_method **********"
    puts self.inspect
    puts self.class
    puts "**********"
  end
end

c = C.new
def c.obj_method 
  puts "********** obj_method **********"
  puts self.inspect
  puts self.class
  puts "**********"
end



C.c_method
C.m_inst_method

c.inst_method
# c.m_inst_method
c.obj_method

puts self