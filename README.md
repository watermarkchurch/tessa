# Tessa - asseT management

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

### `config/creds.yml`

This YAML file provides username and passwords for digest authentication
for clients of the API. You can provide as many credentials as is
necessary for your deployment.

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

The format is

```yaml

strategy_name:
  bucket: my-tessa-bucket
  prefix: files/
  ttl: 1800

```

For configuring AWS credentials see the Environment Variables section.

### Environment Variables

AWS credentials and region for the strategies in your system can be
configured with the environment variables `AWS_REGION`,
`AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`.

Tessa uses a PostreSQL database for persisting data on the assets in the
system. You will need to configure a `DATABASE_URL` environment
variables to a PostgreSQL database.

You will also need to configure `DIGEST_AUTH_OPAQUE` for the digest
authentication to function securely.

## Contributing

See [CONTRIBUTING.md][contributing]

[contributing]: https://github.com/watermarkchurch/tessa/blob/master/CONTRIBUTING.md
