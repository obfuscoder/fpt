# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "fpt"
set :repo_url, "https://github.com/obfuscoder/fpt.git"

set :deploy_to, '/home/fpt/www2'

append :linked_dirs, 'log', 'tmp'
