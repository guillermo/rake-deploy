# Rake-deploy

A deploy system using rake. Maybe a light version of capistrano

## Motivation

Capistrano is a great project, maybe a little big in some cases, but with one big problem: it aims to cover all possible use cases.

rake-deploy is like a simple version of capistrano, and only intended to be the clumping of the most common to all projects: The management of versions of code.

The basic operation of rake-deploy is based on three principles:

  * Add a configuration task environment.
  * A set of tasks provided by rake-deploy.
  * Hooks for each of the tasks with rake-hooks
  
## Usage

In your Rakefile add:

    require 'rake/deploy'

In any of your task files (for example, for rails: lib/tasks/deploy.rake)

    deploy.application = "app_name"
    deploy.deploy_to   = "/apps/app_name"
    deploy.repository  = "ssh://user@github.com/myrepo.git"
    deploy.host        = "esther.cientifico.net"
    
Now you can do:
    rake deploy:setup  # To create app skeleton
    rake deploy        # To deploy
    
## Recipes
    
For example, imagine you wan't to restart passanger, rake-deploy will not do it for you so just write:

    after :deploy do
      deploy.run(deploy.host, "touch #{deploy.deploy_to}/current/tmp/restart.txt")
    end
    
Or you want to make a backup of your database in each deploy
    
    before :deploy do
      deploy.run("db.my_company.com", "mysqldump -u root my_app_db_production | gzip > /var/backups/#{deploy.release_name}.db.sql.bz2")
    end
    
You can see more recipes, that you most copy and paste and edit in your files in the wiki:

http://wiki.github.com/guillermo/rake-deploy/recipes

## Conventions

  * Use git.
  * Don't use sudo (really need super user to deploy?)
  * Use ssh keys from you to the server and from the server to the repo
  * Use /current /releases/#{date} /shared schema in server (deploy:setup makes it for you)
  * Use /shared/scaffold as a scaffold of your app. There will be the data shared between releases like database.yml, /tmp, /log or /public/shared
  * User /shared/repo as a bare clone of your remote remote

## Author

Guillermo Álvarez <guillermo@cientifico.net>

## Web

http://github.com/guillermo/rake-deploy

## Date of writing 
  
22 Jul 2010
