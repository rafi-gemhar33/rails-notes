
# 4_modules_and_program_organization

- modules encourage modular design
-  modules are bundles of methods and constants.
- modules don’t have instances
- add the functionality of a particular module to a class or an object.
- Class class is a subclass of the Module class
- modules are the more basic structure, and classes are just a specialization
- `Kernel` module that contains the majority of the methods common to all objects.
- method-lookup process works when both classes and modules are involved.

## Basics of module creation and use

- modules get mixed in to classes, using `include` or `prepend` method(mix-in)
- can mix in more than one module

### require/load vs. syntax of include
- `require` or `load`, name of the item is in "quotation marks";
  - `require and load` are locating and loading disk files
- `include`, `extend`, and `prepend`, you don’t
  - `include, extend, & prepend` perform a program-space, in-memory operation & has nothing to do with files

Example:
```rb
require_relative "stacklike"
class Stack
  include Stacklike
end
```
- __class__ name is a **noun**, the __module__ name is an **adjective**.


## Modules, classes, and method lookup
- a method can always go as far up as BasicObject.
-  `Kernel`, a module that `Object` mixes in
- The internal definitions of `BasicObject`, `Object`, and `Kernel` are written in` C`
- class that doesn’t have an explicit super- class is a subclass of Object

- modules are searched in reverse order of inclusion, most recently mixed-in module is searched first
- re-including a module doesn’t do anything. 


### prepend
- if you **pre**pend a module to a class, the object looks in that module first, before it looks in the class.
- `.ancestors` class method gives look up order... of a Class

### extend works
- `extend`, will make a module’s methods available as class methods.
- extending module doesn’t add it to class’s ancestor chain

### Final Order
1. Modules prepended to its class, in reverse order of prepending
2. Its class
3. Modules included in its class, in reverse order of inclusion
4 Modules prepended to its superclass
5 Its class’s superclass
6 Modules included in its superclass

### super
- for navigating the lookup path explicitly: the keyword `super`.
- call to super:
  - even if object find a method corresponding to the message, it must keep looking and find the next match.

- **Called with no argument list** (empty or otherwise), `super` automatically forwards the arguments that were passed to the method from which it’s called.
- **Called with an empty argument list** `super()` sends no arguments to the higher-up method, even if arguments were passed to the current method.
- **Called with specific arguments** `super(a,b,c)` sends exactly those
arguments.

### Inspecting method hierarchies with method and super_method
```rb
t = Tandem.new(1)
tandem_rent = t.method(:rent) ### => #<Method: Tandem#rent>
tandem_rent.call

bicycle_rent = t.method(:rent).super_method ### => #<Method: Bicycle#rent>
bicycle_rent.call
```

## method_missing
- method signature: `method_missing(m, *args)` + argument to bind to a code block
- `Kernel module` provides an instance method called `method_missing`.
- to intercept calls to missing methods; override `method_missing`, 
  * either on a singleton
  * or in the object’s class 
  * or one of that class’s ancestors:

### Combining method_missing and super
```rb
class Student
  def method_missing(m, *args)
  if m.to_s.starts_with("grade_for_")
    puts "You got an A in #{m.to_s.split("_").last.capitalize}!" 
  else
    super
  end
  end
end
```

### class-versus-module decisions:
- Modules don’t have instances
- A class can have only one superclass, but it can mix in as many modules as it wants

## Nesting modules and classes
- used to create separate namespaces for `classes`, `modules`, and `methods`.
```rb
module Tools
  class Hammer
  end
end

h = Tools::Hammer.new
```
-  `Tools::Hammer`, you can’t tell solely from this what’s a `class` and what’s a `module` or whether `Hammer` is a constant.
- nesting or chaining of names in a way that makes sense.
- `classes` are `modules` — class `Class` is a subclass of the class `Module`
- `Tools::Hammer` notation itself doesn’t tell you everything without looking at the source code or the documentation


## PARADOX
**BasicObject is an Object, and Object is a Class, and Class is an Object.**

## Ruby operators
- `+=`, `-=`, `*=`, `/=`, `**=` (raise to a power), 
- `&=` (bitwise AND), 
- `|=` (bitwise OR), 
- `^=` (bitwise EXCLUSIVE OR),
- `%=` (modulo), and and-equals operator 
- (`&&=`) that works similarly to or-equals.
- (`||=`) that works similarly to or-equals.

`x=x+y #####==>  x = x.+(y)`