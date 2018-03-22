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
# Keyring dependencies
# Keyring gem is currently unable to correcly detect the following downlaod
# https://github.com/jheiss/keyring/blob/master/ext/mkrf_conf.rb#L26
# http://en.wikibooks.org/wiki/Ruby_Programming/RubyGems#How_to_install_different_versions_of_gems_depending_on_which_version_of_ruby_the_installee_is_using
case Gem::Platform.local.os
  when "linux"
    require "gir_ffi-gnome_keyring"
  when "darwin"
    require "ruby-keychain"
end

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
