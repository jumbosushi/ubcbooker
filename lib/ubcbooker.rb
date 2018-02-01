require "pry"
require "mechanize"
require "io/console" # For handling password
require "optparse"
require "yaml"

module Ubcbooker
  # TODO: before 0.1
  # - TDD
  # - Catch when login fails
  # - Selection with arrow keys (tty-prompt)
  BOOKING_URL = {
    cs: "https://my.cs.ubc.ca/docs/project-rooms-and-dlc",
    sauder_ugrad: "https://booking.sauder.ubc.ca/ugr/cwl-login",
  }
end

require "ubcbooker/version"
require "ubcbooker/error"
require "ubcbooker/color"
require "ubcbooker/config"
require "ubcbooker/cli"
