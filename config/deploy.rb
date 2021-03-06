# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'hubot-deploy-sample-app'
set :repo_url, 'git@github.com:conol/hubot-deploy-sample-app.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

if ENV['REVISION'].nil?
  ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
else
  set :branch, ENV['REVISION']
end

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ubuntu/app/#{fetch :application}-#{fetch :stage}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('node_modules', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :bundle_without, nil
set :bundle_flags, nil
set :bundle_binstubs, nil

set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'
set :rbenv_map_bins, %w(rake gem bundle ruby rails)

set :default_env, {
  'PATH' => '$HOME/.nvm/versions/node/v4.1.2/bin:$PATH'
}

namespace :deploy do

  namespace :config do
    desc 'Upload config files'
    task :upload do
      on roles(:app) do |host|
        execute :mkdir, '-p', "#{shared_path}/config"

        upload! 'config/database.yml', "#{shared_path}/config/database.yml"
        upload! 'config/secrets.yml', "#{shared_path}/config/secrets.yml"
      end
    end
  end

  desc 'Restart unicorn'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Execute `rake tmp:cache:clear`'
  task :clear_cache do
    on roles(:web) do
      within release_path do
        execute :rake, 'tmp:cache:clear'
      end
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
after 'deploy:restart', 'deploy:clear_cache'
