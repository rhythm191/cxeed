# frozen_string_literal: true
require 'thor'
require 'cxeed'

module Cxeed
  class Command < Thor
    desc 'init', 'initialize credential'
    def init
      cred = Cxeed::Credential.new

      login_url = ask "input login url #{ cred.login_url&.empty? ? '' : "(#{cred.login_url})" }:"
      cred.login_url = login_url unless login_url.empty?

      company_code = ask "input company code #{ cred.company_code&.empty? ? '' : "(#{cred.company_code})" }:"
      cred.company_code = company_code unless company_code.empty?

      employee_code = ask "input employee code #{ cred.employee_code&.empty? ? '' : "(#{cred.employee_code})" }:"
      cred.employee_code = employee_code unless employee_code.empty?

      password = ask '(required!)input password:', echo: false
      cred.password = password

      cred.store
    end

    desc 'cred', 'show credential'
    def cred
      cred = Cxeed::Credential.new

      say "login url    : #{ cred.login_url }"
      say "company code : #{ cred.company_code }"
      say "employee code: #{ cred.employee_code }"
      say "password     : #{ cred.password }"
    end

    desc 'login_test', 'login_test'
    def login_test
      cred = Cxeed::Credential.new
      proxy = Cxeed::Proxy.new cred

      if proxy.login_test == 'https://cxg2.i-abs.co.jp/cyberx/Xgw0001.asp?CxClientDispFlg=0'
        say 'login success'
      else
        say 'login fail'
      end
    end

    desc 'arrive [time] [date]', 'submit arrival time (time format is "%H:%M") (date format 2017/09/27)'
    def arrive(time = Time.now.strftime('%H:%M'), date = Time.now.strftime('%Y/%m/%d'))
      cred = Cxeed::Credential.new
      proxy = Cxeed::Proxy.new cred

      proxy.arrive time, DateTime.parse(date)

      puts "arrive #{ date } #{ time}"
    end

    desc 'leave [time] [date]', 'submit leave time (time format is "%H:%M") (date format 2017/09/27)'
    def leave(time = Time.now.strftime('%H:%M'), date = Time.now.strftime('%Y/%m/%d'))
      cred = Cxeed::Credential.new
      proxy = Cxeed::Proxy.new cred

      proxy.leave time, DateTime.parse(date)

      puts "leave #{ date } #{ time }"
    end

    desc 'today', 'show today attendance'
    def today
      cred = Cxeed::Credential.new
      proxy = Cxeed::Proxy.new cred

      today = proxy.today

      puts "today(#{ today.date.strftime('%m/%d') }) #{ today.attendance_time }"
    end

    desc 'attendance date(format: %Y/%m/%d)', 'show day attendance'
    def attendance(date)
      cred = Cxeed::Credential.new
      proxy = Cxeed::Proxy.new cred

      attendance = proxy.day_attendance date

      puts "#{ attendance.date.strftime('%Y/%m/%d') } #{ attendance.attendance_time }"
    end
  end
end
