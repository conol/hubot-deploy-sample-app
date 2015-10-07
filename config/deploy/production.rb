set :rails_env, 'production'
set :unicorn_rack_env, 'deployment'

server '54.65.164.152',
  roles: %w{app db web},
  ssh_options: {
    forward_agent: true,
    auth_methods: %w{publickey},
  }
