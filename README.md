# README

[IOI](https://investinopen.org) Infra Finder.

## Setting up for local development

Ensure you have docker, docker-compose, and docker-sync (`gem install docker-sync`) installed.

### Credentials

If you are developing the core application, copy the master key from the  1Password and put it in place:
`pbpaste > config/master.key`. If you are running this in your own environment, you will need to fork and
generate your own credentials for development, staging, and production:

```bash
rm config/credentials.yml.enc config/credentials/{staging,production}.yml.enc

bin/rails credentials:edit # for dev credentials, only secret_key_base needs to be set
bin/rails credentials:edit --environment staging
bin/rails credentials:edit --environment production
```

### Starting

`docker-sync` must always be running in order to have changes persist between your host and the docker container.

```bash
docker-sync start

# Now launch / build the containers.
docker-compose up -d
```

This will automatically run migrations and seed the database with migrations, seeds, etc.

### Setting up your admin account

You can launch a console inside the docker environment via `bin/console`. To make a new user for dev, launch one and:

```ruby
user = InfraFinder::Container["testing.add_super_admin"].("youremail@investinopen.org", "Your Name").value!;
```

The randomly-generated password will get printed to the console. You can then sign in by going to [the admin section](http://localhost:6856/admin).

## Local Usage

### Accessing the local site

The frontend is available at [http://localhost:6856](http://localhost:6856).

### Accessing Mailcatcher

All mail sent in a local environment is sent to the `mailcatcher` container.

You can browse those messages here: [http://localhost:6857/](http://localhost:6857/).

### Changing ruby gems

Modify the Gemfile and run `docker-compose exec web bundle` as needed.

### Changing node.js packages

Run `docker-compose exec web yarn add PACKAGEHERE`.

**Note**: Do not run yarn on your local machine. It needs to happen in Docker. `node_modules` is not and cannot be shared between the two environments.

## Adding more view components

To add a view component, use the Rails generator. From your local machine:

```bash
docker-compose exec web bin/rails g component ComponentName --stimulus
```

The `ComponentName` should be something like `FooBar` in pascal case, and it will generate a component named `FooBarComponent` with its associated sidecar directory `app/components/foo_bar_component`. The `--stimulus` option is necessary to make sure that the generated HTML template is wired up to the component's specific Stimulus controller correctly. After you've done that, you can generate a colocated CSS file and have it automatically be included in the CSS manifest by running the following:

```bash
docker-compose exec web bin/rails view_component:assets:regenerate
```
