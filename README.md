# README

[IOI](https://investinopen.org) Infra Finder.

## Setting up for local development

Ensure you have docker and docker compose (a part of most modern docker installations now).

For running certain ruby and node tasks locally, be sure to have [mise](https://github.com/jdx/mise) installed, and then run `mise install`.

### Credentials

If you are developing the core application, copy the development master key from 1Password and put it in place:
`pbpaste > config/master.key`. If you are running this in your own environment, you will need to fork and
generate your own credentials for development, staging, and production:

```bash
rm config/credentials.yml.enc config/credentials/{staging,production}.yml.enc

bin/rails credentials:edit # for dev credentials, only secret_key_base needs to be set
bin/rails credentials:edit --environment staging
bin/rails credentials:edit --environment production
```

### Starting

The entire stack can be run via `docker compose`.

```bash
# Launch / build the containers.
docker compose up -d
```

This will automatically run migrations and seed the database with migrations, seeds, etc.

### Setting up your admin account

In your local env, you can use the CLI to add a super admin user for testing:

```bash
docker/bin/if-cli users add-super-admin "youremail@investinopen.org" "Your Name"
```

The randomly-generated password will get printed to the console. You can then sign in by going to [the admin section](http://localhost:6856/admin).

## Local Usage

### Accessing the local site

The frontend is available at [http://localhost:6856](http://localhost:6856).

### Accessing Mailcatcher

All mail sent in a local environment is sent to the `mailcatcher` container.

You can browse those messages here: [http://localhost:6857/](http://localhost:6857/).

### Changing ruby gems

Modify the Gemfile and run `docker/bin/exec bundle` as needed.

### Changing node.js packages

Run `mise dev:yarn add PACKAGEHERE`.

**Note**: Do not run yarn on your local machine. It needs to happen in Docker for proper architecture handling. `node_modules` is not and cannot be shared between docker and the host machine.

### Changing node.js or ruby versions

Modify the corresponding version in `mise.toml` and then run `mise install`. It will automatically make sure that the packageManager in package.json is synchronized for other tool usage.

The Dockerfile as well as CI actions use mise as the source of truth to install ruby and node.js, so no further changes are necessary.

### Backing up and restoring a local database

Use the scripts `bin/backup` or `bin/restore path/to/backup.tar`.

Restoring will completely overwrite your local development database as well as your local minio installation. The restore process will automatically restart minio when executed outside of docker.

### Making significant changes to docker

When making significant changes to the Dockerfile or `docker-compose.yml`, a convience script is provided
at `docker/bin/rebuild`.

## Adding more view components

To add a view component, use the Rails generator. From your local machine:

```bash
docker/bin/rails g component ComponentName --stimulus
```

The `ComponentName` should be something like `FooBar` in pascal case, and it will generate a component named `FooBarComponent` with its associated sidecar directory `app/components/foo_bar_component`. The `--stimulus` option is necessary to make sure that the generated HTML template is wired up to the component's specific Stimulus controller correctly. After you've done that, you can generate a colocated CSS file and have it automatically be included in the CSS manifest by running the following:

```bash
docker/bin/rails view_component:assets:regenerate
```

## Changing solution properties

The properties associated with a solution need to be enumerated and defined in a specific way so they can be queried about reasonably within the application. In order to do this, you must modify one of the `.yml` files in `lib/properties`. There is some logical grouping in the files, but largely pick and choose the ones that you would like to use.

Once you've done that, run `docker/bin/rails g solution_properties`. This generator will go through and update all the necessary files related to solution properties.
