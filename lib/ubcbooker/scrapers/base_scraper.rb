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

      def is_logged_in(page)
        page_body = Nokogiri::HTML(page.body)
        login_status_text = page_body.css("p").first.text
        return !login_status_text.include?("Login Failed")
      end

      def populate_account_info(login_page)
        username_feild = login_page.form.field_with(name: "j_username")
        username_feild.value = @username
        password_field = login_page.form.field_with(name: "j_password")
        password_field.value = @password
        redirect_page = login_page.form.submit
        return redirect_page.form.submit
      end

      # Do login for UBC CWL system
      def login_ubc_cwl(login_page)
        begin
          after_login_page = populate_account_info(login_page)
          if is_logged_in(after_login_page)
            return after_login_page
          else
            raise Ubcbooker::Error::LoginFailed
          end
        rescue Ubcbooker::Error::LoginFailed
          puts "Login Failed :/".red
          puts "Please try logging in with different username / password".brown
          puts "You can use `-u` flag to update saved accout info".brown
          exit(1)
        end
      end
    end
  end
end
