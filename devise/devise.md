`rails new myApp -c tailwind -j esbuild -d postgresql -T --main`

-c tailwind 
-j esbuild 
-d postgresql
-T - skip for spec

`cd myApp`

git add .
git commit -m "initial commit"

rails g controller StaticPages root


```rb
# routes.rb
`root 'static_pages#root'`
```

```rb
bundle exec rails db:create
bundle exec rails db:migrate
```

`bundle add letter_opener --group=development`
`bundle add devise` - will add and install
```gemfile
gem "letter_opener", group: :development
gem "devise"
```
`rails g devise:install`
- this sets up the initializer and some local localization for us and it also prints out some instructions so we want to copy.

```rb
# config/environments/development.rb
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
```
- updated action mailer default in the 

```rb
# - Add the alerts in the application.html.erb
# app/views/layouts/application.html.erb
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
```

- devise helpers: user_signed_in? and current_user 
```rb
# 
<% if user_signed_in? % >
# show nav items
<% else % >
# show sign in or register
<% end %>
```

`rails g devise:views`
 with this we have access to a bunch of different templates that we can edit if we need to customize any of the views 

 `rails g model User` or we can directly add `rails g devise User`

 `rails db:migrate`

 `rails g devise User`

- uncomment  the migration table rows
  - Confirmable
  - Recoverable
  - Confirmable
  - Lockable
 ```rb
###db/migrate/20220928194909_add_devise_to_users.rb
 change_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
 ```

```rb
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
```

 `rails db:migrate`

- we also need to go check out our routes file so inside of routes this device for helper method was added
- this new set of routes that is related to authenticating with users resetting their password doing a whole bunch of stuff
in # routes.rb
devise_for :users

- we need to restart our server after we add new gems

get the list of routes by `bundle exec rails routes -E` or from the UI by visiting an invalid route like `localhost:3000/xyz`
- search for `localhost:3000/users/sign_up`

- this is where we can create and register a brand new account inside of rails

open up tailwindui.com and we're going to use tailwind ui's components for our registration page
just copy all of the html from this simple card for registering

take a look here so inside of the views for devise they have several different directories here that are going to help us with confirmations or mailers that are going to be sent password resetting registration or sign ups and so

new template or the new view for the sign up route is where we're going to find the code for the registration the path is : `app/views/devise/registrations/new.html.erb`

update the form  with another input for password 

for the form the action="/users" 
also add the hidden form input `authenticity_token`
 ```
 <input type="hidden" name="authenticity_token" value=<%= form_authenticity_token %> autocomplete="off">
 ```
update the form names in the tailwind ui form

okay the next thing that we want to do here is figure out what the names are on these input boxes so the input here the name is important because this is going to be the key
for setting the params correctly so that it works and plays nicely with device so the name here is user with the email being passed inside of that hash so here on our email input i'm going to go to add `user[name]`
password user[password] & user[password_confirmation] is going to be something different

error message undefined user url for device registrations controller this is most likely because we have not set up devise navigation to support turbo

so by default all these forms if we don't disable turbo it is going to use turbo by default
```rb
####in initialzers/devise
config.navigational_format = ['*/*', :html, :turbo_stream]
```
restart the server
Signup with data.

we need to continue updating the signup view or the registration view so that it doesn't have two forms on the page

if we try to go to users sign up now it's going to say you're already signed in
 

####in initializers/devise
config.sign_out_via = :get
restart the server
`localhost:3000/users/sign_out `

we want to go back to users signup and we want to remove this entire devise generate form from the page
these shared
`<%= render "devise/shared/links" %>` in `app/views/devise/shared/_links.html.erb` are going to potentially come in handy and if we look at the view for that partial which is this shared links partial

you should log in if you're not if you're not on the login page then show a link that shows how to log in if you're not in the sign up page show a link to sign up it also will give you a link to the forgot passwords and so on...


in order to use the tailwind form you should update your tailwind.config to include these plugins so if we go to our tailwind.config.js we can do is just copy this
entire plugins section and drop it.

 now if we look at the server right now you'll notice the server crashed that's because it doesn't have this tailwind css forms component

so we do a `yarn add @tailwindcss/forms` and restart the server `bin/dev`
now that it knows how to find the tailwind css forms component

 inside of `application.html.erb `add `<html class="h-full"` and `<body class="h-full" `

update this copy a little bit and where it says sign into we're going to say register for a new account
 Remove Logo & update `start your 14 day free trial`tp `or log in` with the route `/user/sign_in`
 leave `remember me ` &  the `forgot password link` as we're going to use `remember me` on the sign_in page but we can delete it from the registration page

so let's copy this entire thing over to the `views/sessions/new.html.erb` this is where the login page exists
save this and refresh the page now we see this uh our new tailwind ui h2 to say now `sign in`

look at devise generated remember me and see what names it is using inside of the html so that we can pass those down 
so there are two input boxes here one is a `type="hidden"`input with a `value=0` the other is not hidden `type="checkbox"` with the `value=1` both have `name="user[remember_me]"`

add another tailwind hidden input field 

user remember me this is how devise will know that we intend on actually keeping the user logged in 
The devise generate form has the forgot password link add that in on our sign in page add this to our tailwind ui form path is `/users/password/new` and update the name as well.


 let's go back to the registrations page update the submit button for registration to sign up and now we can remove the `remember me` link from the page  and remove the `forgot password` link


- add authenticate_user before_action
```rb
# app/controllers/application_controller.rb
  before_action :authenticate_user!
```