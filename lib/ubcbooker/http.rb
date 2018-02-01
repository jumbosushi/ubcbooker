require_relative "scrapers/cs.rb"

module Ubcbooker
  class Http
    def book(department)
      # Load & call appropriate scraper here
      puts "Requesting the page ..."
      department_url = BOOKING_URL[department.to_sym]
      @agent.get(department_url) do |page|
        login_page = page.link_with(text: "CWL Login Redirect").click
        login_ubc_cwl(department_url)
      end
    end
  end
end
