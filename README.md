cis550_final_project
====================

Code structure:

The code is designed to follow the MVC paradigm. All queries (other than user login/signup) have been located in app/controllers/home_controller.rb. The views are located in app/views/home (for the normal page) and app/views/devise (for all login/signup pages). app/views/layouts keeps two different page layouts that we use. javascript/css/images are all stored in app/assets (in our production server they are compiled to public/assets so they can be served directly though nginx).

config/routes.rb stores a list of all accepted incoming query urls (make sure to append .json since this is the only format we support)

Database Migrations:
Database migrations are written in ruby inside of timstamped files. These files are locatied in db/migrate/. Notice that we have added an index on ever key and forign key since most operations are over these, so making them an index should gain us modest speed improvements. 

Running the code:
Make sure to have ruby 1.9.3 installed, as well as rails 3. From the root directory of the app run bundle install && rails s to launch the server. Currently I have hardcoded my database password so the instance will use the production database server. If you'd like to run it on your own server change the server information in config/database.yml. Then run rake:db:migrate:seed (since this loads data from all athletes it'll take a while to generate and populate the database).

A test database is currently up at jwils.me:4000. The process has been killed a few times, so if you notice it is down and would like to try it please email jwils@seas.upenn.edu and we will get it back up asap.