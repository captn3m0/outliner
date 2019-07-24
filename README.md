# Outliner [![Gem Version](https://badge.fury.io/rb/outliner.svg)](https://badge.fury.io/rb/outliner)

A simple HTTParty based wrapper for the [Outline API](https://www.getoutline.com/developers). It also offers a one-line import option to let you migrate an existing set of Markdown files to Outline. For quickly running export/import commands, you can use the Docker Image as well.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'outliner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install outliner

## Usage

The API Client automatically picks up the Token from the `OUTLINE_TOKEN` environment variable. All the API calls are available with the `.` replaced with a `_` in the method name. So if you need to call the `collections.remove_user` API, use the `collections_remove_user` method.

```ruby
require 'outliner'

client = Outliner.new('https://knowledge.example.com')
pp client.auth_info
pp client.collections_list(offset: 0, limit: 10)
```

### Import

`outliner` can be used to import an existing collection of documents into Outline. To do this, run:

```bash
export OUTLINE_BASE_URI="https://kb.example.com"
export OUTLINE_TOKEN="PUT YOUR TOKEN HERE"
export SOURCE_DIRECTORY="/home/user/wiki"
export DESTINATION_COLLECTION_NAME="Archive"
bundle install outliner
outliner-import "$SOURCE_DIRECTORY" "$DESTINATION_COLLECTION_NAME"
```

### Export

`outliner` can be used to run a one-time export of all documents in Outline to a local directory. To do this, run:

```bash
export OUTLINE_BASE_URI="https://kb.example.com"
export OUTLINE_TOKEN="PUT YOUR TOKEN HERE"
# Ensure that this exists and is writable
export DESTINATION_DIRECTORY="/data"
bundle install outliner
outliner-export "$DESTINATION_DIRECTORY"
```

## Docker

You can use the pre-built docker image to run the above commands as well. See the following commands for examples:

### Export

```bash
docker run --env OUTLINE_BASE_URI="https://kb.example.com" \
           --env OUTLINE_TOKEN="PUT YOUR TOKEN HERE" \
           --volume /tmp:/data \
           captn3m0/outliner \
           export \
           /data
```

### Import

```bash
docker run --env OUTLINE_BASE_URI="https://kb.example.com" \
           --env OUTLINE_TOKEN="PUT YOUR TOKEN HERE" \
           --volume /path/to/wiki:/data \
           captn3m0/outliner \
           import "/data" "Archive"
```

#### Limitations

- Images are currently not imported. Host them externally for this to work.
- Only `.md` files are currently supported

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/captn3m0/outliner. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Outliner project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/captn3m0/outliner/blob/master/CODE_OF_CONDUCT.md).

## License

Licensed under the [MIT License](https://nemo.mit-license.org/). See LICENSE file for details.
