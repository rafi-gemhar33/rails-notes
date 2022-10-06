- Rails wrapper around the webpack build system

**Sprockets vs webpacker:**
|Task               |Sprockets               |Webpacker           |
|-------------------|------------------------|----------------------|
| Attach JavaScript |	javascript_include_tag |	javascript_pack_tag |
| Attach CSS        |	stylesheet_link_tag    |	stylesheet_pack_tag |
| Link to an image  |	image_url              |	image_pack_tag      |
| Link to an asset  |	asset_url              |	asset_pack_tag      |
| Require a script  |	//= require            |	import or require   |
-----------------------------------------------------------------------

- Webpacker in a new project
  - add `--webpack` to the `rails new` command.

- to an existing project, 
  1. add the `webpacker` gem to `Gemfile`
  2. run `bundle install`
  3. run `bin/rails webpacker:install`

**Webpacker creates the following local files**:

|File              |Location               |Explanation                                |
|------------------|-----------------------|-------------------------------------------|
|JavaScript Folder | `app/javascript`      |A place for your front-end source          |
|Webpacker Config.  | `config/webpacker.yml` |Configure the Webpacker gem                 |
|Babel Config.      | `babel.config.js`      |Babel JavaScript Compiler                  |
|PostCSS Config.    | `postcss.config.js`    |PostCSS CSS Post-Processor                 |
|Browserlist       | `.browserslistrc`     |Browserlist - target browsers configuration |
-----------------------------------------------------------------------

- also yarn package manager, creates a package.json

-  `app/javascript/packs` -> compiled to its own pack file by default.
-  file `app/javascript/packs/application.js`, Webpacker creates a pack `application`, accessible in Rails application with the code `<%= javascript_pack_tag "application" %>`
- file in the actual packs directory will be a manifest.

**default pack :**
```js
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
```
**js structure your source code**
```
app/javascript:
  ├── packs:
  │   # only webpack entry files here
  │   └── application.js
  │   └── application.css
  └── src:
  │   └── my_component.js
  └── stylesheets:
  │   └── my_styles.css
  └── images:
      └── logo.svg
```
- the pack file itself is largely a manifest that uses import or require to load the necessary files
-  change these directories in the `config/webpacker.yml`
  - `source_path` (default `app/javascript`) 
  - `source_entry_path` (default `packs`) 

- Within source files, import statements are resolved relative to the file doing the import
```js
import Bar from "./foo" // finds a foo.js
import Bar from "../src/foo" // finds src/foo.js
```

### Using Webpacker for CSS

- So if your CSS top-level manifest is in `app/javascript/stylesheets/application.scss`, you can import it with `import "stylesheets/application";` in `pack/application.js`.
- load it in the page, include <%= stylesheet_pack_tag "application" %>

### Using Webpacker for Static Assets
- The configuration includes several image and font file format extensions, allowing webpack to include them in the generated `manifest.json` file.

**static assets can be imported directly in JavaScript file**
```js
import myImageUrl from '../images/my-image.jpg'
```

**reference Webpacker static assets from a Rails view**
-  need to be explicitly required from Webpacker-bundled JavaScript files
- Unlike Sprockets, Webpacker does not import your static assets by default.

we can generate the image path by:
```js
const images = require.context("../images", true)
const imagePath = name => images(name, true)
```

- Static assets will be output into a directory under `public/packs/media`
- `app/javascript/images/my-image.jpg` outputs `public/packs/media/images/my-image-abcd1234.jpg`
- render an image tag for this in Rails view, use `image_pack_tag 'media/images/my-image.jpg`
**Sprockets vs webpacker static asset:**
|ActionView helper | Webpacker helper |
|------------------|------------------|
|favicon_link_tag  |favicon_pack_tag  |
|image_tag         |image_pack_tag    |

- `asset_pack_path` takes the local location of a file and returns its Webpacker location
-  file from a `CSS` file access the image directly by referencing `app/javascript`

### Webpacker in Rails Engines
- Webpacker is not "engine-aware," which means Webpacker does not have feature-parity with Sprockets
- distribute frontend assets as an NPM package in addition to the gem itself and provide instructions
- Webpacker out-of-the-box supports HMR with webpack-dev-server

### Webpacker in Different Environments
-  three environments by default `development`, `test`, and `production`.
- additional environment configurations in the `webpacker.yml`
- Webpacker will also load the file `config/webpack/<environment>.js`

### Webpacker in Development
- 2 binstubs `./bin/webpack` and `./bin/webpack-dev-server`
- changing to `compile: false` in the `config/webpacker.yml` file
-  live code reloading or have enough JavaScript that on-demand compilation
    - `./bin/webpack-dev-server` (or) `ruby ./bin/webpack-dev-server`

- development server, Webpacker will automatically start proxying all webpack asset requests to this server

### Deploying Webpacker:
- `webpacker:compile` task to the `assets:precompile` rake task, so any existing deploy pipeline that was using a`ssets:precompile` should work.
-  packs and place them in public/packs.