require 'thor'
require 'cxeed/credential'

module Cxeed
  class Command < Thor
    desc "hello NAME", "say hello to NAME"
    def hello(name)
      puts "Hello #{name}"
    end

    desc 'init', 'initialize credential'
    def init
      cred = Cxeed::Credential.new

      login_url = ask "input login url #{ cred.login_url.empty? ? '' : "(#{cred.login_url})" }:"
      cred.login_url = login_url unless login_url.empty?

      company_code = ask "input company code #{ cred.company_code.empty? ? '' : "(#{cred.company_code})" }:"
      cred.company_code = company_code unless company_code.empty?

      employee_code = ask "input employee code #{ cred.employee_code.empty? ? '' : "(#{cred.employee_code})" }:"
      cred.employee_code = employee_code unless employee_code.empty?

      password = ask '(required!)input password:', echo: false
      cred.password = password

      cred.store
    end
  end
end
