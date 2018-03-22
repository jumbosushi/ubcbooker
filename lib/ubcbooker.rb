require "pry"
require "business_time"
require "tty-spinner"
require "mechanize"
require "typhoeus"
require "obscenity"
require "io/console" # For handling password
require "optparse"
require "yaml"
require "keyring"

module Ubcbooker
  BOOKING_URL = {
    cs: "https://my.cs.ubc.ca/docs/project-rooms-and-dlc",
    # sauder_ugrad: "https://booking.sauder.ubc.ca/ugr/cwl-login",
  }
end

require "ubcbooker/version"
require "ubcbooker/error"
require "ubcbooker/color"
require "ubcbooker/config"
require "ubcbooker/scrapers/scraper"
require "ubcbooker/cli_validator"
require "ubcbooker/cli"
