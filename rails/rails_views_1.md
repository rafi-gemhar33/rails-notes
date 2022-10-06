- app/views/layouts/application.html.erb

- yield method, 
    The view template at app/views/posts/index.html.erb 

### Preprocessors
- erb: executing ruby code inside your HTML
- <%= and %> #executes and returns the ruby code <li><%= user.first_name %></li>
- <% and %> #just executes the ruby code =>   <% if current_user.signed_in? %>

- erb code execution is that it is all done on the server BEFORE the final HTML file is shipped over to the browser
- Rails starts from the outside in with extra extensions. So it first processes the file using ERB, then treats it as regular HTML.
- preprocessors are usually gems that either already come with Rails or can easily be attached to it

### Partials

- use names like _user_form.html.erb
```rb
# <%app/views/users/new.html.erb %>
<%= render "user_form" %>


<%= render partial: "shared/your_partial", :locals => { :user => user } %>
# above code can aalso be written as: 
<%= render "shared/your_partial", :user => user %>

<%= render "user", :locals => {:user => user} %> 
# <%# above code can also be written as:  In that situation, Rails not only finds the _user.html.erb file and passes it the correct user variable to use, it also loops over all the users in your @user collection for you. Pretty handy.%>
<%= render user %> # or <%= render @users %>
```

### Helper Methods
**link_to**
```rb
<%= link_to "See All Users", users_path %> 
<a href="<%= users_path %>">See All Users</a>
```

**Asset Tags**
```rb
  <%= stylesheet_link_tag "your_stylesheet" %>
   <link href="/assets/your_stylesheet.css" media="all" rel="stylesheet">
# ==================================================
  <%= javascript_include_tag "your_javascript" %>
  <script src="/assets/your_javascript.js"></script>
# ==================================================
  <%= image_tag "happy_cat.jpg" %>
  <img src="/assets/happy_cat.jpg">

  ```

## Using render
- `render` tells Rails which view (or other asset) to use in constructing a response
- You can render text, JSON, or XML. 
- debugging: `render_to_string`. This method takes exactly the same options as `render`, but it returns a string instead of sending a response back to the browser.

- render with the name of the view:
```ruby
def update
  if ...
  else ...
   render "edit" # render :edit, status: :unprocessable_entity
  end
end
```
### Rendering an Action's Template from Another Controller
- `render "products/show"` or `render template: "products/show"`

```ruby 
# all of the below calls would render edit template
render :edit
render action: :edit
render "edit"
render action: "edit"
render "books/edit"
render template: "books/edit"
```

### render with :inline
```ruby
render inline: "<% products.each do |p| %><p><%= p.name %></p><% end %>"
render inline: "xml.p {'Horrid coding practice!'}", type: :builder
```
### Rendering different types of values:

```ruby
### Rendering Text =================================== ###
render plain: "OK"
### Rendering HTML =================================== ###
render html: helpers.tag.strong('Not Found')
### Rendering JSON =================================== ###
render json: @product
### Rendering xml =================================== ###
render xml: @product
### Rendering Vanilla JavaScript =================================== ###
render js: "alert('Hello Rails');"
### Rendering raw body =================================== ###
render body: "raw"
### Rendering raw file =================================== ###
render file: "#{Rails.root}/public/404.html", layout: false
```

### Options for render

Options for render
##### :content_type
- default: MIME content-type of text/html (or application/json if you use the :json option, or application/xml for the :xml option.)
```rb
render template: "feed", content_type: "application/rss"
```
##### :layout
default:  as part of the current layout.
```ruby
render layout: "special_layout"
render layout: false # no layout at all.
```
##### :location
- :location option to set the HTTP Location header:
default: 
```rb
render xml: photo, location: photo_url(photo)
```
##### :status
- default: Rails will automatically generate a response with the correct HTTP status code
```rb
render status: 500
render status: :forbidden
```
##### :formats
- default: Rails uses the format specified in the request(or :html by default)
```rb
render formats: :xml
render formats: [:json, :xml]

```
##### :variants
-  look for template variations of the same format
```rb
# called in HomeController#index
render variants: [:mobile, :desktop]
# With this set of variants Rails will look for the following set of templates and use the first that exists.
# app/views/home/index.html+mobile.erb
# app/views/home/index.html+desktop.erb
# app/views/home/index.html.erb

```

### Layouts
- To find the current layout: first looks for a file in `app/views/layouts` with the same base name as the controller

For PhotosController
1. `app/views/layouts/photos.html.erb` or `app/views/layouts/photos.builder`.
2. `app/views/layouts/application.html.erb` or `app/views/layouts/application.builder`

For example 
```rb
class ProductsController < ApplicationController
  layout "inventory"

# ProductsController will use app/views/layouts/inventory.html.erb
```
- So we can do a conditional layout like
```rb
class ProductsController < ApplicationController
  layout :products_layout # or   layout "product", except: [:index, :rss]
...
  private
    def products_layout
      @current_user.special? ? "special" : "products"
...

```

- a Proc, to determine the layout. For example, if you pass a Proc object, the block you give the Proc will be given the controller instance

```rb
class ProductsController < ApplicationController
  layout Proc.new { |controller| controller.request.xhr? ? "popup" : "application" }
```
### Layout/template Inheritance

Similar to the Layout Inheritance logic, if a template or partial is not found in the conventional path, the controller will look for a template or partial to render in its inheritance chain

```rb
# app/views/admin/products/index.html.erb 
<%= render @products || "empty_list" %> #>

# app/views/application/_empty_list.html.erb
There are no items in this list <em>yet</em>.

```

**Avoiding Double Render Errors**

## Using redirect_to
- it tells the browser to send a new request for a different URL. 
- For example, you could redirect from wherever you are in your code to the index of photos in your application with this call:

- `redirect_back` to return the user to the page they just came from. This location is pulled from the `HTTP_REFERER` header
```rb
redirect_back(fallback_location: root_path)
```

Rails uses HTTP status code 302, a temporary redirect, we can specify  status code, perhaps 301, a permanent redirect
```rb
redirect_to photos_path, status: 301
```


## head To Build Header-Only Responses
- The head method accepts a number or symbol(status_symbols).

```rb
head :created, location: photo_path(@photo)

# This would produce the following header:
  # HTTP/1.1 201 Created
  # Connection: close
  # Date: Sun, 24 Jan 2010 12:16:44 GMT
  # Transfer-Encoding: chunked
  # Location: /photos/1
  # Content-Type: text/html; charset=utf-8
  # X-Runtime: 0.083496
  # Set-Cookie: _blog_session=...snip...; path=/; HttpOnly
  # Cache-Control: no-cache
```
## Structuring Layouts  

- `Asset tags`
- `yield and content_for`
- `Partials`

### Asset Tag Helpers
* [**auto_discovery_link_tag**](https://api.rubyonrails.org/v7.0.4/classes/ActionView/Helpers/AssetTagHelper.html#method-i-auto_discovery_link_tag)
  - within head tag<head>:
  - detect the presence of RSS, Atom, or JSON feeds
  - takes `:rss`, `:atom`, or `:json`
  ```rb
  auto_discovery_link_tag(:rss, {action: "feed"}, {title: "My RSS"})
  # => <link rel="alternate" type="application/rss+xml" title="My RSS" href="http://www.currenthost.com/controller/feed" />

  ```
* [**javascript_include_tag**](https://api.rubyonrails.org/v7.0.4/classes/ActionView/Helpers/AssetTagHelper.html#method-i-javascript_include_tag)
  - HTML `<script>` tag for each source provided.
  - If Asset Pipeline enabled would generate a link to` /assets/javascripts/` rather than `public/javascripts`. This link is then served by the asset pipeline.
  - JS files lives inside `app/assets`, `lib/assets` or `vendor/assets`
  - The request to this asset is then served by the Sprockets gem.
  ```rb
  <%= javascript_include_tag "main" % >
  # => <script src='/assets/main.js'></script>
  #=============================================
  javascript_include_tag "common.javascript", "/elsewhere/cools"
  # => <script src="/assets/common.javascript.debug-1284139606.js"></script>
  # => <script src="/elsewhere/cools.debug-1284139606.js"></script>

  ```

- [**stylesheet_link_tag**](https://api.rubyonrails.org/v7.0.4/classes/ActionView/Helpers/AssetTagHelper.html#method-i-stylesheet_link_tag)
  * returns an HTML <link> tag for each source provided.
  * if "Asset Pipeline" enabled, this will generate a link to `/assets/stylesheets/`
  * A stylesheet file can be stored in one of three locations: `app/assets`, `lib/assets`, or `vendor/assets`.
  ```rb
  stylesheet_link_tag "style"
  # => <link href="/assets/style.css" rel="stylesheet" />

  #=============================================
  stylesheet_link_tag "random.styles", "/css/stylish"
  # => <link href="/assets/random.styles" rel="stylesheet" />
  # => <link href="/css/stylish.css" rel="stylesheet" />
  ```

- [**image_tag**](https://api.rubyonrails.org/v7.0.4/classes/ActionView/Helpers/AssetTagHelper.html#method-i-image_tag)
  * builds an HTML `<img />`
  * By default, files are loaded from public/images.
  * alt:, size:, supply a final hash of standard HTML options, such as :class, :id, or :name:
  ```rb
  image_tag("icon")
  # => <img src="/assets/icon" />
  image_tag "home.gif", alt: "Go Home",
                        id: "HomeImage",
                        class: "nav_bar"

  ```

- [**video_tag**](https://api.rubyonrails.org/v7.0.4/classes/ActionView/Helpers/AssetTagHelper.html#method-i-video_tag)
  * helper builds an HTML5 `<video>`
  * files are loaded from public/videos.
  ```rb
  video_tag("trailer")
  # => <video src="/videos/trailer"></video>
  video_tag(["trailer.ogg", "movie.ogg"])
  # => <video>
  #      <source src="/videos/trailer.ogg">
  #      <source src="/videos/movie.ogg">
  #    </video>
  ```
    - **poster**: "image_name.png", provides an image to put in place of the video before it starts playing.
    - **autoplay**: true, starts playing the video on page load.
    - **loop**: true, loops the video once it gets to the end.
    - **controls**: true, provides browser supplied controls for the user to interact with the video.
    - **autobuffer**: true, the video will pre load the file for the user on page load.


- [**audio_tag**](https://api.rubyonrails.org/v7.0.4/classes/ActionView/Helpers/AssetTagHelper.html#method-i-audio_tag)
  * builds an HTML5 <audio>
  * default, files are loaded from public/audios
  ```rb
    audio_tag("sound")
    # => <audio src="/audios/sound"></audio>
  ```
  * autoplay: true, starts playing the audio on page load
  * controls: true, provides browser supplied controls for the user to interact with the audio.
  * autobuffer: true, the audio will pre load the file for the user on page load.

###  yield
- main body of the view will always render into the unnamed `yield`
- render content into a named `yield`, you use the `content_for` method.

```rb
<html>
  <head>
  <%= yield :head %>
  </head>
  <body>
  <%= yield %>
  </body>
</html>
```

### content_for 
- The `content_for` method allows you to insert content into a _named_ `yield` block in your layout.
```rb
<% content_for :head do %>
  <title>A simple page</title>
<% end %>
<p>Hello, Rails!</p>
#========================================
<html>
  <head>
  <title>A simple page</title>
  </head>
  <body>
  <p>Hello, Rails!</p>
  </body>
</html>

```

### Using Partials
- Using Partials to Simplify Views
```rb
  render "menu" # => render a file named _menu.html.erb
```
 **Partial Layouts**

```rb 
 <%= render partial: "link_area", layout: "graybar" %>

```
**Passing Local Variables**
```rb
# new.html.erb
<h1>New zone</h1>
<%= render partial: "form", locals: {zone: @zone} % >

#_form.html.erb
<%= form_with model: zone do |form| %>
```
-  it is possible to use the partial without the need to declare all local variables.
```rb
<%= render partial: "customer", object: @new_customer %
#short hand => <%= render @customer %>
```
- Assuming that the `@customer` instance variable contains an instance of the `Customer` model, this will use `_customer.html.erb` to render it and will pass the local variable `customer` into the partial which will refer to the `@customer` instance variable in the parent view.

- You can pass an object in to this local variable via the :object option:
```rb
<%= render partial: "customer", object: @new_customer %>
```
- Within the customer partial, the customer variable will refer to @new_customer from the parent view.

**Rendering Collections**
-pass a list of model to a partial via the `:collection` option, the partial will be inserted once for each member in the collection:
```rb
# index.html.erb
<h1>Products</h1>
<%= render partial: "product", collection: @products % > # short-hand => <%= render @products %>
# _product.html.erb
<p>Product Name: <%= product.name %></p>
```

- Rails determines the name of the partial to use by looking at the model name in the collection. 
- you can even create a heterogeneous collection

**Local Variables**
- To use a custom local variable name within the partial, specify the :as option
- You can also pass in arbitrary local variables to any partial you are rendering with the locals: {} option:
```rb
<%= render partial: "product", collection: @products,
           as: :item, locals: {title: "Products Page"} %>

```
**Spacer Templates**
- You can also specify a second partial to be rendered between instances of the main partial by using the` :spacer_template` option:
```rb
<%= render partial: @products, spacer_template: "product_ruler" %>
```
- Rails will render the _product_ruler partial (with no data passed in to it) between each pair of _product partials.

**Collection Partial Layouts**
- The layout will be rendered together with the partial for each item in the collection
```rb
<%= render partial: "product", collection: @products, layout: "special_layout" %>
```

### [Nested Layouts](https://guides.rubyonrails.org/layouts_and_rendering.html#using-nested-layouts)