module Ubcbooker
  module Scraper
    class BaseScraper
      def initialize(username, password)
        @agent = Mechanize.new do |agent|
          agent.user_agent_alias = "Linux Mozilla"
        end
        @username = username
        @password = password
      end

      # Do login for UBC CWL system
      def login_ubc_cwl(login_page)
        username_feild = login_page.form.field_with(name: "j_username")
        username_feild.value = @username
        password_field = login_page.form.field_with(name: "j_password")
        password_field.value = @password
        redirect_page = login_page.form.submit
        return redirect_page.form.submit
      end
    end
  end
end
