require "ubcbooker/version"
require 'io/console' # For handling password
require 'mechanize'
require 'pry'

module Ubcbooker
  # TODO:
  # - Gemify
  # - TDD
  # - Catch when login fails
  # - Feature to save password
  # - Use Thor for CLI
  # - Divide up to files

  class User
    attr_accessor :username, :password
  end

  print "CWL username: "
  username = gets.chomp
  print "CWL password: "
  # Hide the password input
  password = STDIN.noecho(&:gets).chomp
  puts

  a = Mechanize.new do |agent|
    agent.user_agent_alias = 'Linux Mozilla'
  end

  # What happens if I'm already logged in here?
  # Maybe check by seeing if the CWL link pops up after GET

  # Do login for UBC CWL system
  def login_ubc_cwl(login_page)
    username_feild = login_page.form.field_with(:name => "j_username")
    username_feild.value = username
    password_field = login_page.form.field_with(:name => "j_password")
    password_field.value = password
    redirect_page = login_page.form.submit
    return reditect_page.form.submit
  end

  puts "Requesting the page ..."
  a.get('https://my.cs.ubc.ca/docs/project-rooms-and-dlc') do |page|
    login_page = page.link_with(:text => "CWL Login Redirect").click
    login_ubc_cwl(login_page)
    binding.pry
  end

end
