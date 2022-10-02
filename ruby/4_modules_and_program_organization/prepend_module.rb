
module MyModule1
  def ruby_veriosn
    puts "MyModule M"
  end
end


module MyModule2p
  def ruby_veriosn
    puts "MyModule2 M2"
  end
end



module ParentModule1
  def ruby_veriosn
    puts "ParentModule M"
  end
end

class ParentTester1
  prepend ParentModule1

  def ruby_veriosn
    puts "ParentTester C"
  end
end

class ModuleTester1 < ParentTester1
  prepend MyModule2p
  prepend MyModule1

end

