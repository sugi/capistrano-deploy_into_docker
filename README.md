# capistrano-deploy\_into\_docker

[![Gem Version](https://badge.fury.io/rb/capistrano-deploy_into_docker.svg)](https://badge.fury.io/rb/capistrano-deploy_into_docker)

Mini support task file to deploy app into docker.

## Installation

Add in your Gemfile;

```ruby
gem 'capistrano-deploy_into_docker', '>= 0.2.0', group: :development
```

## HowTo: deploy your rails application into docker

### Require task on Capfile

Add following like to your Capfile;

```ruby
require 'capistrano/deploy_into_docker'
```

This just add `deploy_into_docker:commit` task.

### Deploy setting

You need to set `::sshkit_backend` to `SSHKit::Backend::Docker`.

Here is an example for config/deploy/docker.rb;

```ruby
set :sshkit_backend, SSHKit::Backend::Docker
set :stage, :production
set :branch, 'production'
set :deploy_to, '/var/local/app'
set :git_shallow_clone, 1
fetch(:default_env).merge!(rails_env: :production, SECRET_KEY_BASE: 'dummy', DEVISE_SECRET_KEY: 'dummy')

fetch(:linked_dirs, []).clear
fetch(:linked_files, []).clear

server docker: {
    image: 'sugi/rails-base',
    commit: 'myapp-web',
  }, user: 'rails:rails', roles: %w{web app}
```

## Server definition as Docker host

You need to set docker environment as host infomation hash.
The hash requires `:image` (or :container) key to run.

```ruby
server docker: {image: 'ruby:latest'}
```

If you set `:commit` key, run "docker commit" after deploy automatically.

```ruby
server docker: {
    image: 'sugi/rails-base:latest',
    commit: 'new-image-name:tag',
  }, user: 'nobody:nogroup', roles: %w{web app}
```

In addtion, you can add any options for "docker run". for example;

```ruby
server docker: {
    image: 'ruby:latest',
    commit: 'new-image-name:tag',
    volume: ['/storage/tmp:/tmp', '/storage/home:/home'],
    network: 'my-net',
    dns: '8.8.8.8',
    dns_search: 'example.com',
    cap_add: ['SYS_NICE', 'SYS_RESOURCE'],
  }, user: 'nobody:nogroup', roles: %w{web app}
```

## Copyright

Author: Tatsuki Sugiura

Files are distributed under [MIT License](https://opensource.org/licenses/MIT).
