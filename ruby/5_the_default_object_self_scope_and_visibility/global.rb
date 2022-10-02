$gvar = "some dope sh**"

class C
  def do_something
    p $gvar
  end
end

c = C.new
c.do_something