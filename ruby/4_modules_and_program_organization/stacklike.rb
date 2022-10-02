module Stacklike

  def stack
    @stack ||= []
  end

  def add_to_stack(item)
    @stack.push item
  end
  
  def remove_from_stack
    @stack.pop
  end
end