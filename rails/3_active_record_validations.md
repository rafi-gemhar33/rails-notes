# Active Record Validations

## Overview

```rb
class Person < ApplicationRecord
  validates :name, presence: true
end


Person.create(name: "John Doe").valid? #true
Person.create(name: nil).valid? # false
```

  ### Other options
  - database constraints, client-side validations and controller-level validations

  - Database constraints: 
    - Safely handle some things (such as uniqueness in heavily-used tables)
    - database is used by other applications

  - Client-side validations
    - are generally unreliable if used alone
    - provide users with immediate feedback
  - Controller-level validations `XXX`
    - keep your controllers skinny

  - Active Record uses the `new_record?` instance method to determine whether an object is already in the database or not
  - `.save` => send an `SQL INSERT` operation to the database

  ### methods triggerring validations
  - create
  - create!
  - save
  - save!
  - update
  - update!

  - `bang` versions `raise an exception` if invalid. 
  - The `non-bang` versions don't: save and update `return false`, 
  - create returns the `object`.

  ### Skipping Validations:
  - decrement!, decrement_counter
  - increment!, increment_counter
  - insert, insert!
  - insert_all, insert_all!
  - toggle!
  - touch, touch_all
  - update_all, update_attribute, update_column, update_columns, update_counters
  - upsert, upsert_all

  save skips validations if passed `validate: false` argument.
  ```rb
  .save(validate: false)
  ```

  ### valid? and invalid?
  - `valid?` triggers your validations  returns true if no errors in object
  - any errors found can be accessed through the `errors` instance method
  - object instantiated with `new` will not report errors

  ```rb
  # validates :name, presence: true
  p = Person.new   #=> #<Person id: nil, name: nil>
  p.errors.size   #=> 0

  p.valid?   #=> false
  p.errors.objects.first.full_message   #=> "Name can't be blank"
  ```

  - `invalid?` is the inverse of `valid?`. It triggers your validations,

  ### errors[]
  - `errors[:attribute]`returns array all error messages for`:attribute`
  - only useful after validations have run


## Validation Helpers
- Active Record hs many pre-defined validation helpers
- can add the same kind of validation to several attributes.
- All of them accept `:on` & `:message` options
    `:on` => `:create` or `:update`

  ### acceptance
  - default error message for this helper is "must be accepted"
  ```rb
    validates :terms_of_service, acceptance: true
    # acceptance: { message: 'must be abided' }
    # acceptance: { accept: 'yes' }  ### accept defaults to ['1', true]
    # acceptance: { accept: ['TRUE', 'accepted'] }
  ```
  - if you don't have a field for it, the helper will create a virtual attribute.
  - If the field does exist in your db, the accept option must be set to or include true, else the validation will not run.


  ### validates_associated

  ```rb
  validates_associated :books
  ```
  - work with all of the association types.
  - default error message for `validates_associated` is "`is invalid`".
  - errors do not bubble up to the calling model

  ### confirmation
  - confirm an email address or a password
  - validation creates a virtual attribute name is suffixed with "_confirmation".
  ```rb
  validates :email, confirmation: true
  # confirmation: { case_sensitive: false } ### case_sensitive option
  ```
  - check is performed if `email_confirmation` is not nil
  -  make sure to add a presence check
  - default error message => "`doesn't match confirmation`".

  ### comparison
  -  The validator requires a `compare` option.
  - Each option accepts a `value, proc, or symbol`.
  - Used on class includes Comparable
  ```rb
    validates :start_date, comparison: { greater_than: :end_date }
  ```
  options
  - `:greater_than` - "must be greater than %{count}".
  - `:greater_than_or_equal_to` - "must be greater than or equal to %{count}".
  - `:equal_to` -  "must be equal to %{count}".
  - `:less_than` - "must be less than %{count}".
  - `:less_than_or_equal_to` - "must be less than or equal to %{count}".
  - `:other_than` - must be other than %{count}".
 

  ### exclusion
  - attributes' values are not included in a given set
  ```rb
  validates :subdomain, exclusion: { in: %w(www us ca jp), message: "%{value} is reserved." }
    ```
  - `:in` option has an alias called `:within`
  -  default error message is "`is reserved`".

  ### format
  - match a given regular expression, in the `:with` option
  - does not match in the `:without` option
  - default error message is "is invalid".

  ```rb
  validates :email, format: { with: /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/, message: "valid" }
  ```

  ### inclusion
  - attributes' values are included in a given set
  - `:in` option has an alias called `:within`
  - default error message is "`is not included in the list`".

  ```rb
  validates :size, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size"}
  ```
  ### length
  -  length of the attributes' values
  ```rb
  validates :name, length: { minimum: 2 }
  # length: { maximum: 500 }
  # length: { in: 6..20 }
  # length: { is: 6 }

  length: { maximum: 1000, too_long: "%{count} characters is the maximum allowed" } # "is too short (minimum is %{count} characters)
  ```
  options:
  :minimum - 
  :maximum -
  :in (or :within) given interval. The value must be a range.
  :is -

  - default error messages depend on the type of length validation
  - customize error essages using the `:wrong_length`, `:too_long`, and `:too_short` options 
  - %{count} as a placeholder for length 
  - `:in` or `:within` with a lower limit of 1 (or) `:minimum` is 1,
    - either provide custom message or check presence before.


  ### numericality
  - validates attributes have only numeric values.
  - `:only_integer` to true for only integer

  ```rb
    validates :points, numericality: true
    validates :games_played, numericality: { only_integer: true }
  ```
  - doesn't allow `nil` values. bypass it by `allow_nil: true`
  - default error message
    - no options specified - "is not a number".
    - for :only_integer - "must be an integer"

   options:                      default error message
    `:greater_than`              `be greater than %{count}`
    `:greater_than_or_equal_to`  `must be greater than or equal to %{count}`
    `:equal_to`                  `be equal to %{count}`
    `:less_than`                 `be less than %{count}`
    `:less_than_or_equal_to`     `be less than or equal to %{count}`
    `:other_than`                `be other than %{count}`
    `:in`                        `be in %{count}`
    `:odd`                       `be odd`
    `:even`                      `be even`


  ### presence
  - It uses the `blank?` method
  - nil or a blank string,(empty or consists of whitespace.)
  ```rb
    validates :name, :login, :email, presence: true
    # check for associated object reather than the foreign key
    has_one :account
    validates :account, presence: true

    # to validate associated records' presence, specify the `:inverse_of` option 
    has_many :line_items, inverse_of: :order

    # for boolean `false.blank?` is `true` so use
    inclusion: [true, false]
    exclusion: [nil]
  ```
  - `has_one` or `has_many` relationship, check that the object is neither` blank?` nor `marked_for_destruction?`.'


  ### absence
  -  It uses the `present?` method to check value is not nil or blank string
  ```rb
    validates :name, :login, :email, absence: true

    # test whether the associated object itself is absen
    belongs_to :order
    validates :order, absence: true

    #  validate associated records whose absence is required
      has_many :line_items, inverse_of: :order

    # for boolean false.present? is false
    validates :field_name, exclusion: { in: [true, false] }.
    ```
    - `has_one` or `has_many` relationship, check the object is neither `present?` nor `marked_for_destruction?`
    -  default error message is "must be blank".

  ### uniqueness
  - attribute's value is unique right before the object gets saved.
  - doesn't create uniqueness constraint in database 
  - you must create a unique index on that column in your database.
  - default error message is "has already been taken".
  ```rb
   validates :email, uniqueness: true
   
   # :scope option to limit the uniqueness check:
   validates :name, uniqueness: { scope: :year, message: "should happen once per year" }

   # :case_sensitive option 
   validates :email, uniqueness: { case_sensitive: false }
  ```

  ### validates_with
  - no default error message
  - `validates_with` takes the `:if`, `:unless` and `:on` options
  ```rb
  class GoodnessValidator < ActiveModel::Validator
    def validate(record)
      if record.first_name == "Evil"
        record.errors.add :base, "This person is evil"
      end
    end
  end

  class Person < ApplicationRecord
    validates_with GoodnessValidator
  end
  ```

  ### validates_each
  - attributes against a block
  -  block receives the record, the attribute's name, and the attribute's value. 
  ```rb
  class Person < ApplicationRecord
    validates_each :name, :surname do |record, attr, value|
      record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
    end
  end
  ```

## Common Validation Options
  ### :allow_nil
  - skips the validation value is `nil?`
  ```rb
    validates :size, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }, allow_nil: true
    ```
  ### :allow_blank
  - skips the validation if the attribute's value is `blank?`, like nil

  ```rb
  validates :title, length: { is: 5 }, allow_blank: true
  ```
  ### :message
  - `:message` option accepts a String or Proc.
  -  string can contain `%{value}`, `%{attribute}`, & `%{model} `
  - Proc `:message` is given two arguments: the `object` & a hash with` :model, :attribute, and :value` key-value pairs.

  ```rb
  validates :name, presence: { message: "must be given please" }

  # `%{value}`, `%{attribute}`, & `%{model} ` will be available
  validates :age, numericality: { message: "%{value} seems wrong" }

  # Proc
  validates :username,
    uniqueness: {
      # object = person object 
      # data = { model: "Person", attribute: "Username", value: <username> }
      message: ->(object, data) do
        "Hey #{object.name}, #{data[:value]} is already taken."
      end
    }
  ```
  ### :on

  - option lets you specify when the validation should happen
  - default behavior is run on both create & update
  - define custom contexts
  ```rb
    validates :email, uniqueness: true, on: :account_setup
    validates :age, numericality: true, on: :account_setup

    ##########################################
    person = Person.new(age: 'thirty-three')
    person.valid? # true
    person.valid?(:account_setup) # false 
    person.save(context: :account_setup) # false 
    person.errors.messages # {:email=>["has already been taken"], :age=>["is not a number"]}
  ```

## Strict Validations
  ```rb
    validates :name, presence: { strict: true }

    Person.new.valid? # ActiveModel::StrictValidationFailed: Name can't be blank
    
    #  custom exception to the :strict
    validates :token, presence: true, uniqueness: true, strict: TokenGenerationException
    Person.new.valid? # TokenGenerationException: Token can't be blank
  ```

## Conditional Validation
  - `:if` and `:unless` options, can take a `symbol`, `Proc` or `Array`. 

  ```rb
  validates :card_number, presence: true, if: :paid_with_card?

  def paid_with_card?
    payment_type == "card"
  end

  #  a Pro or lambda with :if and :unless
  validates :password, confirmation: true, unless: Proc.new { |a| a.password.blank? }
  validates :password, confirmation: true, unless: -> { password.blank? }
  ```

  ### Grouping Conditional validations

    ```rb
    with_options if: :is_admin? do |admin|
      admin.validates :password, length: { minimum: 10 }
      admin.validates :email, presence: true
    end
    ```

  ### Combining Validation Conditions
  ```rb
    validates :mouse, presence: true,
                      if: [Proc.new { |c| c.market.retail? }, :desktop?],
                      unless: Proc.new { |c| c.trackpad.present? }
  ```


## Performing Custom Validations

  ```rb
  class MyValidator < ActiveModel::Validator
    def validate(record)
      unless record.name.start_with? 'X'
        record.errors.add :name, "Need a name starting with X please!"
      end
    end
  end

  class Person
    include ActiveModel::Validations
    validates_with MyValidator
  end
  ```

  ### ActiveModel::EachValidator
  ```rb
  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors.add attribute, (options[:message] || "is not an email")
      end
    end
  end

  class Person < ApplicationRecord
    validates :email, presence: true, email: true
  end

  ```

### Custom Methods
  - You can pass more than one symbol
  - validations will run in the same order as they were registered.

  ```rb
  class Invoice < ApplicationRecord
    validate :expiration_date_cannot_be_in_the_past, :discount_cannot_be_greater_than_total_value
    validate :active_customer, on: :create

    def expiration_date_cannot_be_in_the_past
      if expiration_date.present? && expiration_date < Date.today
        errors.add(:expiration_date, "can't be in the past")
      end
    end

    def discount_cannot_be_greater_than_total_value
      if discount > total_value
        errors.add(:discount, "can't be greater than total value")
      end
    end

    def active_customer
      errors.add(:customer_id, "is not active") unless customer.active?
    end
  end
  ```

## Working with Validation Errors
  - ActiveModel::Errors
  ### errors
  - returns an instance of `ActiveModel::Errors`
  - contains all errors, 
  - each error instance of ` ActiveModel::Error` object
  ```rb
  person.valid? # => false
  person.errors.full_messages # => ["Name can't be blank", "Name is too short (minimum is 3 characters)"]
  ```
  ### errors[]
  - for a specific attribute

  ### errors.where and error object
  - `where` returns an array of error objects, filtered by conditions.

  ```rb
  person = Person.new
  person.valid? # => false
  person.errors.where(:name) # => [ ... ] # all errors for :name attribute
  person.errors.where(:name, :too_short) # => [ ... ] # :too_short errors for :name attribute


  error = person.errors.where(:name).last
  error.attribute  # => :name
  error.type  # => :too_short
  error.options[:count]  # => 3
  error.message # -> "is too short (minimum is 3 characters)"
  error.full_message # -> "Name is too short (minimum is 3 characters)"
  ```

  ### errors.add
  add method creates error object by taking the attribute, type, options hash
  - `add(attribute, type = :invalid, **options)`
  ```rb
  errors.add :name, :too_plain, message: "is not cool enough"
  ```

  ### errors[:base]
  - add errors  object's state as a whole
  ```rb
  errors.add :base, :invalid, message: "This person is invalid because ..."

  person = Person.create
  person.errors.where(:base).first.full_message # => "This person is invalid because ..."
  ```

  ### errors.clear
  - intentionally to clear errors collection
  - `errors.clear` on invalid object won't make it valid:

  ### errors.size
  - returns the total number of errors
  ```rb
  validates :name, presence: true, length: { minimum: 3 }

  person = Person.new
  person.errors.size  # => 2
  ```


## Displaying Validation Errors in Views
  - generating a scaffold, Rails will put some ERB into the `_form.html.erb`

  ```erb
  ...
  <ul>
    <% @article.errors.each do |error| %>
      <li><%= error.full_message %></li>
    <% end %>
  </ul>
  ...

  - if we use form helpers to generate your form
  ```erb
  <div class="field_with_errors">
    <input id="article_title" ...">
  ```