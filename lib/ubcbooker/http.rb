module Ubcbooker
  class Http
    attr_accessor :agent

    def initialize
      @agent = Mechanize.new do |agent|
        agent.user_agent_alias = "Linux Mozilla"
      end
    end

    # Do login for UBC CWL system
    def login_ubc_cwl(username, password, login_page)
      username_feild = login_page.form.field_with(name: "j_username")
      username_feild.value = username
      password_field = login_page.form.field_with(name: "j_password")
      password_field.value = password
      redirect_page = login_page.form.submit
      binding.pry
      return redirect_page.form.submit
    end

    def login(username, password)
      puts "Requesting the page ..."
      binding.pry
      @agent.get("https://my.cs.ubc.ca/docs/project-rooms-and-dlc") do |page|
        login_page = page.link_with(text: "CWL Login Redirect").click
        login_ubc_cwl(username, password, login_page)
      end
    end
  end
end
