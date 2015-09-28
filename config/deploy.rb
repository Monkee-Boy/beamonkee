# config valid only for current version of Capistrano
lock '<4.0.0'

# Load up the mBoy gem
Mboy.new() # Setting initial defaults.

set :application, 'join-the-troop' # no spaces or special characters
set :project_name, 'Join The Troop' # pretty name that can have spaces
set :repo_url, 'git@github.com:Monkee-Boy/jointhetroop.git' # the git repo url
set :repo_tree, '_site'
set :current_dir, 'public_html' # almost always public_html

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('') # Note that this file must exist on the server already, Capistrano will not create it.

# Default value for linked_dirs is []
set :linked_dirs, %w{node_modules bower_components wufoo}

namespace :deploy do
  STDOUT.sync

  desc 'Build'
  after :updated, :deploybuild do
    on roles(:web) do
      within release_path  do
        invoke 'build:npm'
        invoke 'build:bower'
      end
    end
  end

  desc 'mBoy Deployment Initialized.'
  Mboy.deploy_starting_message

  desc 'Tag this release in git.'
  Mboy.tag_release

  desc 'mBoy Deployment Steps'
  Mboy.deploy_steps

  #desc 'mBoy HipChat Notifications'
  #Mboy.hipchat_notify

end

namespace :build do

  desc 'Install/update node packages.'
  task :npm do
    on roles(:web) do
      within release_path do
        execute :npm, 'install --silent --no-spin' # install packages
      end
    end
  end

  desc 'Additional deploy steps for :build'
  before :npm, :deploy_step_beforenpm do
    on roles(:all) do
      print 'Updating node modules......'
    end
  end

  after :npm, :deploy_step_afternpm do
    on roles(:all) do
      puts '✔'.green
    end
  end

  desc 'Install/update bower components.'
  task :bower do
    on roles(:web) do
      within release_path do
        execute :bower, 'install' # install components
      end
    end
  end

  before :bower, :deploy_step_beforebower do
    on roles(:all) do
      print 'Updating bower components......'
    end
  end

  after :bower, :deploy_step_afterbower do
    on roles(:all) do
      puts '✔'.green
    end
  end

end
