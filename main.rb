require 'io/console' # For handling password

require 'rubygems'
require 'mechanize'
require 'ruby-progressbar'
require 'pry'

print "CWL username: "
username = gets.chomp
print "CWL password: "
# Hide the password input
password = STDIN.noecho(&:gets).chomp
puts
puts "Requesting the page ..."

# Progress bar
progressbar = ProgressBar.create
50.times { progressbar.increment; sleep 0.01 }

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Linux Mozilla'
}

# Getting started example
# a.get('http://google.com/') do |page|
#   search_result = page.form_with(:name => 'f') do |search|
#     binding.pry
#     search.q = 'Hello world'
#   end.submit
#
#   search_result.links.each do |link|
#     puts link.text
#   end
# end

# What happens if I'm already logged in here?
# Maybe check by seeing if the CWL link pops up after GET
a.get('https://my.cs.ubc.ca/docs/project-rooms-and-dlc') do |page|
  login_page = page.link_with(:text => "CWL Login Redirect").click
  username_feild = login_page.form.field_with(:type => "text")
  password_field = login_page.form.field_with(:type => "password")
  binding.pry
end
