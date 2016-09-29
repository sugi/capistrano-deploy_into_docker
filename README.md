# capistrano-deploy\_into\_docker

[![Gem Version](https://badge.fury.io/rb/capistrano-deploy_into_docker.svg)](https://badge.fury.io/rb/capistrano-deploy_into_docker)

Mini support task to deploy app into docker.

## Installation

Add in your Gemfile;

```ruby
gem 'capistrano-deploy_into_docker', '>= 0.2.0', group: :development
```

## HowTo: deploy your rails application into docker

### 1) Require task on Capfile

Add following like to your Capfile;

```ruby
require 'capistrano/deploy_into_docker'
```

This just add `deploy_into_docker:commit` task.

### 2) Create new deploy setting for docker

You need to set `:sshkit_backend` to `SSHKit::Backend::Docker`.

Here is an example for config/deploy/docker.rb;

```ruby
set :sshkit_backend, SSHKit::Backend::Docker
set :stage, :production
set :branch, 'production'
set :deploy_to, '/app'
fetch(:default_env).merge!(rails_env: :production, RAILS_SERVE_STATIC_FILES: 1,
			   SECRET_KEY_BASE: 'dummy', DEVISE_SECRET_KEY: 'dummy')

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
  }, user: 'rails:rails', roles: %w{web app}
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

## Tips

### Stop to run some tasks only in docker deploy stage

Use `Rake::Task["target:name"].clear`, for example;

```ruby
Rake::Task["passenger:restart"].clear
```

You can stop to run any target by calling clear method in deploy/_stage-name_.rb.

### Deploy as handy development test

If you run docker on localhost, mount current source dir as docker volume to test purpose
(Note: I do NOT suggest this tric to build production environment).

For example;

```ruby
set :sshkit_backend, SSHKit::Backend::Docker
set :stage, :development
set :branch, 'master'
set :deploy_to, '/app'
fetch(:default_env).merge!(rails_env: :development, SECRET_KEY_BASE: 'dummy', DEVISE_SECRET_KEY: 'dummy')
set :bundle_without, 'test'
set :repo_url, '/src'        # <--------- Use source from mounted volume.

fetch(:linked_dirs, []).clear
fetch(:linked_files, []).clear

server docker: {
  image: 'nvc-base',
  commit: 'nvc-test',
  volume: "#{Dir.pwd}:/src",  # <---------- Mount current source as docker volume.
}, user: 'rails:rails', roles: %w{web app}
```

## Copyright

Author: Tatsuki Sugiura

Files are distributed under [MIT License](https://opensource.org/licenses/MIT).
