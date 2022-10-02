
module MyModule
  def ruby_veriosn
    puts "MyModule M"
  end
end


module MyModule2
  def ruby_veriosn
    puts "MyModule2 M2"
  end
end



module ParentModule
  def ruby_veriosn
    puts "ParentModule M"
  end
end

class ParentTester
  include ParentModule

  def ruby_veriosn
    puts "ParentTester C"
  end
end

class ModuleTester < ParentTester
  include MyModule2
  include MyModule

end

