# Tessa - asseT management

[ ![Build Status][3]    ][4]
[ ![Coverage Status][5] ][6]
[ ![Code Climate][7]    ][8]
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/watermarkchurch/tessa)

Tessa is a small web API that manages assets by providing links to
upload, download, and delete remote files via HTTP. It has a database to
track metadata on all of the assets it has provided links for.

With this version Tessa only provides links for Amazon S3, but it could
theoretically support any system that allows for signed links to manage
files.

See the [tessa-client][tessa-client] project for a client implementation
for this service.

[tessa-client]: https://github.com/watermarkchurch/tessa-client

## Configuration

Credentials and strategies can be configured in one of two ways. Through
a JSON encoded environment variable or through a YAML config file.

### `config/creds.yml`

This YAML file provides username and passwords for basic authentication
for clients of the API. You can provide as many credentials as is
necessary for your deployment. The schema is:

```yaml

username1: password1
username2: password2

```

This can also be configured through the `TESSA_CREDENTIALS` environment
variable. See the Environment Variables section below.

### `config/strategies.yml`

The strategies file allows you to configure multiple strategies for file
storage. In this version all strategies are for AWS S3. These are the
possible options:

* `bucket`: Name of the S3 bucket
* `prefix`: Prefix for all keys generated in this strategy
* `acl`: The acl for new files in this strategy
* `region`: The AWS region
* `ttl`: Time to live in seconds for signed links generated by Tessa
  (default is 900).
* `region`: AWS region (defaults to `AWS_REGION` environment variable)
* `credentials`: AWS access and secret keys (defaults to respective
  environment variables)

The format is

```yaml

strategy_name:
  bucket: my-tessa-bucket
  prefix: files/
  ttl: 1800
  region: "us-east-1"
  credentials:
    access_key_id: "ABC123"
    secret_access_key: "DEF456"

```

The `region` and `credentials` config items are optional if you provide
the AWS prefixed environment variables. See the Environment Variables
section below.

Warning: signed downloads will not work if the `region` config does not actually
match the region of the bucket.

Strategies can also be configured through the `TESSA_STRATEGIES`
environment variable. See the Environment Variables section below.

### Environment Variables

Default AWS credentials and region for the strategies in your system can
be configured with the environment variables `AWS_REGION`,
`AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`. Each strategy can
override the settings given, but these will be used if none is provided.

Tessa uses a PostreSQL database for persisting data on the assets in the
system. You will need to configure a `DATABASE_URL` environment
variables to a PostgreSQL database.

`TESSA_CREDENTIALS` when set will take precedence over the YAML config
file. It has the same schema, but is JSON encoded. For example:
`{"username":"password"}`.

`TESSA_STRATEGIES` when set will take precedence over the YAML config
file. It has the same schema, but is JSON encoded. For example:
`{"strategy_name":{"bucket":"my-tessa-bucket","prefix":"files/","ttl":1800}}`

## Development

To get started with development first follow the instructions on
Watermark's [devenv repository][9]. Once that is setup and working clone
down this repository and do the following:

- Get your AWS credentials and put them in [your creds.yml file](#Configuration)
- `bin/setup` - Run a few app setup tasks
- `$ docker-compose up` - Start up necessary Docker containers
- Visit `http://tessa.wcc` in your browser. You should see the app!
- Run the test suite with `$ docker-compose run web rspec`
- If you need to create any development specific configuration do it in
  the `.env[.ENV].local` file.

This should be all you need to get a working development environment. If
you're having trouble please get in touch with us at dev@watermark.org.
We'd be glad to help.

## Contributing

See [CONTRIBUTING.md][contributing]

[contributing]: https://github.com/watermarkchurch/tessa/blob/master/CONTRIBUTING.md

[0]: https://github.com/watermarkchurch/tessa
[1]: https://img.shields.io/gem/v/tessa.svg?style=flat
[2]: http://rubygems.org/gems/tessa "Gem Version"
[3]: https://img.shields.io/travis/watermarkchurch/tessa/master.svg?style=flat
[4]: https://travis-ci.org/watermarkchurch/tessa "Build Status"
[5]: https://codeclimate.com/github/watermarkchurch/tessa/badges/coverage.svg
[6]: https://codeclimate.com/github/watermarkchurch/tessa "Coverage Status"
[7]: https://img.shields.io/codeclimate/github/watermarkchurch/tessa.svg?style=flat
[8]: https://codeclimate.com/github/watermarkchurch/tessa "Code Climate"
[9]: https://github.com/watermarkchurch/devenv
