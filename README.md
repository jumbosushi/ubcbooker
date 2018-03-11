# Ubcbooker

CLI tool to book project rooms in UBC

## Installation

Install it as:

    $ gem install ubcbooker

For use in your application, add this line to your Gemfile:

```ruby
gem 'ubcbooker'
```

And then execute:

    $ bundle

## Usage

```
# Book Computer Science project rooms
$ ubcbooker cs
# Book Sauder project rooms
$ ubcbooker sauder
```

```
# Call help
$ ubcbooker -h
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jumbosushi/ubcbooker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ubcbooker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jumbosushi/ubcbooker/blob/master/CODE_OF_CONDUCT.md).
