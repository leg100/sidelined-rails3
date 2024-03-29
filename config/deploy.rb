set :application, 'sidelined'
set :repo_url, 'git@bitbucket.org:garman/sidelined-rails3.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :scm, :git
set :user, 'louis'
set :use_sudo, false
set :rails_env, "production"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/var/www/rails"

set :rbenv_ruby, '2.0.0-p247'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_type, :user # or :system, depends on your rbenv setup

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  after :updated, :create_link_to_angular do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :rm, '-rf', 'public'
        execute :ln, '-s', '/var/www/angular', 'public'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
