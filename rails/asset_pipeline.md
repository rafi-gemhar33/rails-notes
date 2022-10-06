- Rails recommended best practice is to allow the asset pipeline to handle css and use Webpack only for Javascript assets
- Rails’ flatten everything out and mash all your asset files together into one big one for each filetype (called “concatenation”)

### Manifest Files
- javascript manifest file will be `app/assets/javascripts/application.js`
//= tell Rails which files to go find and include
```js
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
```
- `require_tree` helper method just grabs everything in the current directory.
- Rails now uses the `rails_ujs` instead 

- stylesheet manifest file operates similarly – it’s available: `app/assets/stylesheets/application.css`
```css
/*
 *
 *= require_tree .
 *= require_self
 */
```
- Controller in Rails generates a directory for views related to the controller where your HTML lives and it also creates a stylesheet in the same name.

- `CatController` => `cat.scss`

- <%= javascript_include_tag "application" %>, Rails automatically knows which filename to request to get all your javascripts properly imported.

#### Rails in Development
-  in the local environment, it actually sends out a whole bunch of stylesheets
- <%= image_tag "fuzzy_slippers.jpg" %>.
Preprocessors
- 
#### Un-Escaping HTML
```
  <%= raw "<p>hello world!</p>" %> 
   CGI::escapeHTML('usage: foo "bar" <baz>')
```

=====================================================================================================

- Sprockets concatenates all JavaScript files into one master .js file and all CSS files into one master .css file.
-  implemented by the sprockets-rails gem
```rb
#  rails new appname --skip-asset-pipeline

# Gemfile
gem 'sassc-rails'

# production.rb
config.assets.css_compressor = :yui
config.assets.js_compressor = :terser
```

In production, Rails inserts an SHA256 fingerprint, changes to file alters this fingerprint,
1. concatenate assets
2. asset minification or compression
3. it allows coding assets via a higher-level language, with precompilation down to the actual assets

#### What is Fingerprinting and Why S
 **cache busting**: When the content is updated, the fingerprint will change =>  remote clients to request a new copy of the content. 

 - Sprockets insert a hash of the content into the name,
 - Rails' old strategy was to append a date-based query string 
 - enable or disable Fingerprinting in configuration `config.assets.digest` option.

### Use the Asset Pipeline
 - Rails' old versions, all assets were located in subdir. of `public` as `images`, `javascripts` and `stylesheets`
 - But Sprockets middleware serves from `app/assets`; for files that must undergo some pre-processing.In production rails precompiles these files to `public/assets`
 - assets under public will be served if `config.public_file_server.enabled: true`
 
#### Controller Specific Assets
- Rails by default generates a `app/assets/stylesheets/projects.scss` for `ProjectsController`.
- By default these files will be ready to use by your application immediately using the require_tree
- include controller specific stylesheets and JavaScript files. Ensure you are not using the `require_tree` directive, as that will result in your assets being included more than once.
```erb
<%= javascript_include_tag params[:controller] %>
<%= stylesheet_link_tag params[:controller] %>
```

### Asset Organization
`app/assets`: owned by the application, such as custom images, JavaScript files, or stylesheets.
`lib/assets`: own libraries' code that doesn't really fit into the scope of the application or shared across multi apps.
`vendor/assets`:  is for assets that are owned by outside entities,

#### Search Paths
- When a file is referenced from a manifest or a helper, Sprockets searches the three default asset locations for it.
- any path under assets/*

```js
app/assets/javascripts/home.js
//= require home

lib/assets/javascripts/moovinator.js
//= require moovinator

 vendor/assets/javascripts/slider.js
//= require slider

vendor/assets/somepackage/phonebox.js
//= require phonebox

// would be referenced in a manifest like this:


app/assets/javascripts/sub/something.js
//= require sub/something

```

- search path by inspecting `Rails.application.config.assets.paths` in the Rails console.

- paths can be added to the pipeline in `config/initializers/assets.rb`
```rb
Rails.application.config.assets.paths << Rails.root.join("lib", "videoplayer", "flash")
```
- `app/assets` take precedence, and will mask paths in `lib` and `vendor`.
- files you want to reference outside a manifest must be added to the precompile array or they are unavailable in prod ENV


#### Using Index Files
- for `lib/assets/javascripts/library_name` => `lib/assets/javascripts/library_name/index.js` serves as the manifest for all files;
- this file could include a list of all the required files in order, or a simple require_tree directive.
//= require library_name

### Coding Links to Assets

Sprockets methods
```erb
<%= stylesheet_link_tag "application", media: "all" %>
<%= javascript_include_tag "application" %>
```

- `turbolinks gem`, included by default in Rails, then include the `'data-turbo-track'` option which causes Turbo to check if an asset has been updated and if so loads it into the page
```erb
<%= stylesheet_link_tag "application", media: "all", "data-turbo-track" => "reload" %>
<%= javascript_include_tag "application", "data-turbo-track" => "reload" %>
```

`public/assets/rails.png` will be served by Sprockets to `<%= image_tag "rails.png" %>`

- In production a request for a file with an SHA256 hash such as public/assets/rails-f90d8a84c707a8dc923fca1ca1895ae8ed0a09237f6992015fef1e11be77c023.png

- Sprockets will also look through the paths specified in `config.assets.paths`
- Images can also be organized into subdirectories if required.

- Production precompiling will raise an exception for asset not exist,

### CSS and ERB

- The asset pipeline automatically evaluates ERB
- `application.css.erb` then helpers like `asset_path` are available in your CSS rules
-  `data URI` - a method of embedding the image data directly into the CSS file - use the `asset_data_uri`

### CSS and Sass
- `sass-rails` provides `-url` and `-path` helpers
- `image-url("rails.png")` returns `url(/assets/rails.png)`
- `image-path("rails.png")` returns `"/assets/rails.png"`

- `asset-url("rails.png")` returns `url(/assets/rails.png)`
- `asset-path("rails.png")` returns `"/assets/rails.png"`

### JavaScript/CoffeeScript and ERB
- add `erb` like `application.js.erb`, you can then use the `asset_path` helper


### Manifest Files and Directives
- Sprockets uses manifest files to determine which assets to include and serve
- manifest files has directives - instructions to Sprockets, which files to require to build a single CSS/JavaScript file
- Sprockets loads the files specified,
  -  processes them if necessary, 
  - concatenates them into one single file,
  - and then compresses them (based on value of Rails.application.config.assets.js_compressor)

`app/assets/javascripts/application.js`
```js
// ...
//= require rails-ujs
//= require turbolinks
//= require_tree .
```
- In `.js` files Sprockets directives begin with `//=`
- `require` and the `require_tree` directives

- Here, you are requiring the files `rails-ujs.js` and `turbolinks.js` that are available somewhere in the search path for Sprockets.
- You need not supply the extensions explicitly. Sprockets assumes you are requiring a `.js` file when done from within a `.js` file.

- `require_tree` directive tells Sprockets to recursively include all `js` files in the specified directory into the output
-  These paths must be specified relative to the `manifest file`
- `require_directory` directive which includes all `js` files only in the directory specified, without recursion.

- Directives are processed top to bottom, but the order in which files are included by `require_tree` is unspecified.
- require the prerequisite file first in the manifest to ensure some particular JavaScript ends up above some other.

- default `app/assets/stylesheets/application.css`

```css
/* ...
 *= require_self
 *= require_tree .
 */
```

- The directives that work in JavaScript files also work in stylesheets 
- `require_tree` directive in a CSS manifest works similarly JavaScript one, requiring all stylesheets from the current directory.
- you should generally use the Sass @import rule instead of these Sprockets directives
- You can do file globbing as well using `@import "*"`, and `@import "**/*"` to add the whole tree which is equivalent to how `require_tree` works.

- You can have as many manifest files as you need. For example, the `admin.css` and `admin.js`

you can specify individual files and they are compiled in the order specified.you might concatenate three CSS files together this way:
```css
/* ...
 *= require reset
 *= require layout
 *= require chrome
 */
```

### Preprocessing
- Rails by default generates a `app/assets/stylesheets/projects.scss` for `ProjectsController`.
- In development mode, or if the asset pipeline is disabled when this file is requested it is processed by the processor provided by the sass-rails gem and then sent back to the browser as CSS
- `app/assets/stylesheets/projects.scss.erb` is first processed as ERB, then SCSS, and finally served as CSS

### In Development

```js
//= require core
//= require projects
//= require tickets
```
- This manifest `app/assets/javascripts/application.js` would generate this HTML:
```html
<script src="/assets/application-728742f3b9daa182fe7c831f6a3b8fa87609b4007fdc2f87c134a07b19ad93fb.js"></script>
```

- an error will be raised when an asset cannot be found.
```rb
config.assets.unknown_asset_fallback = false
```

- `config/environments/development.rb`
```rb
### Turning Digests Off
config.assets.digest = false

#========================================================================================================
# Turning Source Maps On
# When debug mode is on, Sprockets will generate a Source Map for each asset. 
# This allows you to debug each file individually in your browser's developer tools.
config.assets.debug = true
```


### In Production
```erb
<%= javascript_include_tag "application" %>
<%= stylesheet_link_tag "application" %>
```
```js
<script src="/assets/application-908e25f4bf641868d8683022a5b62f54.js"></script>
<link href="/assets/application-4dd5b109ee3439da54f5bdfd78a80473.css" rel="stylesheet" />
```
- fingerprinting behavior is controlled by the config.assets.digest

### Precompiling Assets

```
RAILS_ENV=production rails assets:precompile
```

```rb
config.assets.prefix to shared/assets
```

- default matcher for compiling files includes application.js, application.css and all non-JS/CSS files (this will include all image assets automatically) from app/assets folders

- other manifests or individual stylesheets and JavaScript files to include, you can add them to the precompile array in` config/initializers/assets.rb`
```rb
Rails.application.config.assets.precompile += %w( admin.js admin.css )
```

- The command also generates a `.sprockets-manifest-randomhex.json` (where randomhex is a 16-byte random hex string) that contains a list with all your assets and their respective fingerprints. 
- This is used by the Rails helper methods to avoid handing the mapping requests back to Sprockets. A typical manifest file looks like:

- config.assets.prefix ('/assets')

#### Far-future Expires Header
 They do not have far-future headers by default, so update your server configuration to add those headers.
 For NGINX:
```
location ~ ^/assets/ {
  expires 1y;
  add_header Cache-Control public;

  add_header ETag "";
}
```

- To ensure that the development server always compiles assets on-the-fly
<!-- config/environments/development.rb: -->
```rb
config.assets.prefix = "/dev-assets"
```

### Live Compilation
```rb
config.assets.compile = true
```

### Customizing the Pipeline
```rb
config.assets.css_compressor = :yui
config.assets.css_compressor = :sass
config.assets.js_compressor = :terser
config.assets.gzip = false # disable gzipped assets generation
```

### Using Your Own Compressor
```rb
class Transformer
  def compress(string)
    do_something_returning_a_string(string)
  end
end
# =======================================application.rb:=======================================
config.assets.css_compressor = Transformer.new
```

### Changing the assets Path
```rb
config.assets.prefix = "/some_other_path"
```

### X-Sendfile header
- to ignore the response from the application, and instead serve a specified file from disk.
```
# config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
# config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX
```

### Assets Cache Store
- Sprockets caches assets in `tmp/cache/assets`
```rb
config.assets.configure do |env|
  env.cache = ActiveSupport::Cache.lookup_store(:memory_store,
                                                { size: 32.megabytes })
end

lookup_store(:null_store) # disable the assets cache store:
```

### Adding Assets to Your Gems

- engine class which inherits from Rails::Engine.
- By doing this, Rails is informed that the directory for this gem may contain assets and the `app/assets`, `lib/assets` and `vendor/assets`

### Making Your Library or Gem a Pre-Processor