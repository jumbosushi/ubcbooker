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
$ ubcbooker --helj

Usage: ubcbooker [options]
    -b, --building BUILDING          Specify which department to book rooms from
    -d, --date DATE                  Specify date to book rooms for (MM/DD)
    -h, --help                       Show this help message
    -l, --list                       List supported departments
    -n, --name NAME                  Name of the booking
    -t, --time TIME                  Specify time to book rooms for (HH:MM-HH:MM)
    -u, --update                     Update username and password
    -v, --version                    Show version

ex. Book a room in CS from 11am to 1pm on March 5th with the name 'Study Group'
    $> ubcbooker -b cs -n 'Study Group' -d 03/05 -t 11:00-13:00
```

Currently this app supports project rooms in cs (Commputer Science).
Feel free to send a PR that supports your department's rooms.

## Development

After checking out the repo, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ubcbooker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jumbosushi/ubcbooker/blob/master/CODE_OF_CONDUCT.md).
