Sample App
============

Sample app based on Sinatra, Grape and Sequel

## Installation

Installation and running app requires few simple steps:

1. Clone project and cd into its folder
2. Run `bundle install` command
3. Create database in psql and specify url to it in `DATABASE_URL` env variable *(or use .env file)*
4. Run `rake db:migrate` command to create all required tables
5. Run `rake db:seed` command to seed database with initial random data
6. Start server. I recommend using Thin that built into project by running `thin start`. It will automatically load `config.ru` file that will start the app.

## Specs

Project has pretty good code coverage using RSpec. So you can simply run `bundle exec rspec` command to see if your changes broke something or not. Also project has guard installed, that waits for any changes in project folder and runs RSpec, Rubocop and Bundler for any related changes. You can start it by running `bundle exec guard` command

## Endpoints

Main Grape module listening on `/api/` endpoint. Currently it has only one version. So all the endpoints located under `/api/v1` path

### Profile

Contains all operations related to current user profile management

* **GET /profile** - Disaplays current user info
* **PUT /profile** - Update public user parameters *(name, email)*
* **PUT /profile/change_password** - Update user password

### Posts

* **GET /posts** - Displays all posts. It has pagination that renders 30 posts per page by default. Use `per_page` parameter to cahnge this behavior. Use `page` parameter to switch between pages. This endpoint renders posts body preview that includes only first 100 characters of post body and comments count. To see full body and comments use **GET /posts/:id** endpoint
* **GET /posts/:id** - Renders full post
* **POST /posts** - Create new post. Requires auth and body parameter for post body
* **PUT /posts/:id** - Update post. Requires auth and body parameter for post body. Allows only user that created post or admin to update it
* **DELETE /posts/:id** - Delete post. Requires auth. Allows only user that created post or admin to delete it

### Comments

Lives under posts endpoint.

* **POST /posts/:post_id/comments** - Create new comment. Requires auth and text parameter for comment text
* **PUT /posts/:post_id/comments/:id** - Update comment. Requires auth and text parameter. Allows only user that created comment or admin to update it
* **DELETE /posts/:post_id/comments/:id** - Delete comment. Requires auth. Allows only user that created comment or admin to delete it

For more info about API use swagger. You can find it under `/api/v1/swagger_doc` endpoint

## Technologies stack

* Sinatra and sprockets for serving front-end assets *(comming soon)*
* Grape for API
* Grape-entity for representing models and data
* RSpec for testing
* Sequel as an ORM
* PostgreSQL as a database
* Cancancan for authorization
* Unicorn as a production server
