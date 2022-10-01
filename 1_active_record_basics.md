### Active Record Basics

### What is Active Record?
- without writing SQL statements directly


### Convention over Configuration in Active Record
#### Naming:
    Model Class - Singular with the first letter of each word capitalized (e.g., BookClub).
    Database Table - Plural with underscores separating words (e.g., book_clubs).

#### Schema Conventions
- **Foreign keys** - These fields should be named following the pattern `singularized_table_name_id` (e.g., `item_id`, `order_id`). These are the fields that Active Record will look for when you create `associations between your models`.
- **Primary keys** - By default, Active Record will use an integer column named `id` as the table's primary key (`bigint` for PostgreSQL and MySQL, `integer` for SQLite). When using Active Record Migrations to create your tables, this column will be `automatically created`.

- **optional column**

    - **created_at** - Automatically gets set to the current date and time when the record is first created.
    - **updated_at** - Automatically gets set to the current date and time whenever the record is created or updated.
    - **lock_version** - Adds optimistic locking to a model.
    - **type** - Specifies that the model uses Single Table Inheritance.
    - **(association_name)_type** - Stores the type for polymorphic associations.
    - **(table_name)_count** - Used to cache the number of belonging objects on associations.

```rb

```

#### Overriding the Naming Conventions

```rb
class Product < ApplicationRecord
    # ActiveRecord::Base.table_name=
    self.table_name = "my_products"

    # ActiveRecord::Base.primary_key=
    self.primary_key = "product_id"
end


class ProductTest < ActiveSupport::TestCase
    set_fixture_class my_products: Product
    fixtures :my_products
    # ...
end

```


#### CRUD: Reading and Writing Data
##### Create
- `new` method will return a new object while; A call to `user.save` will commit the record to the database.
- `create` will return the object and save it to the database.

##### Read

```rb
# return a collection with all users
users = User.all
# return the first user
user = User.first
# return the first user named David
david = User.find_by(name: 'David')
# find all users named David who are Code Artists and sort by created_at in reverse chronological order
users = User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
```

##### Update

```rb
user = User.find_by(name: 'David')
user.update(name: 'Dave')
User.update_all "max_login_attempts = 3, must_change_password = 'true'"  ## User.update(:all,
```

##### Delete
```rb
user = User.find_by(name: 'David')
user.destroy

# find and delete all users named David
User.destroy_by(name: 'David')

# delete all users
User.destroy_all
```

### Validations
- `save` and `update`: they return false when validation fails 
- `save! and update!`, they raise the exception `ActiveRecord::RecordInvalid`

### Callbacks
- attach code to certain events in the life-cycle of your models. 

### Migrations
- domain-specific language for managing a database schema

```rb
class CreatePublications < ActiveRecord::Migration[7.0]
    def change
        create_table :publications do |t|
    end
```


 - `bin/rails db:migrate`,
 - `bin/rails db:rollback`.