# frozen_string_literal: true
require 'selenium-webdriver'

module Cxeed
  class Proxy
    def initialize(credential)
      caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions': {args: %i(--headless --disable-gpu)})
      @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

      @credential = credential
    end

    def login
      @driver.navigate.to(@credential.login_url)

      # 会社コード入力
      @driver.find_element(:name, 'DataSource').send_keys(@credential.company_code)
      # 個人コード入力
      @driver.find_element(:name, 'LoginID').send_keys(@credential.employee_code)
      # パスワード入力
      @driver.find_element(:name, 'PassWord').send_keys(@credential.password)
      # ログイン処理
      @driver.find_element(:xpath, '//td[@class="loginBtn"]/a').click
    end

    def login_test
      login

      @driver.current_url
    end

    def navigate_to_input_form
      # frameの指定
      @driver.switch_to.frame @driver.find_element(id: 'FRAME1')
      # 勤務データ入力遷移
      @driver.find_element(:xpath, '//a[@title="勤務データ入力"]').click

      # 一旦main documentに戻る
      @driver.switch_to.default_content
      # frameの指定
      @driver.switch_to.frame @driver.find_element(name: 'FRAME2')
    end

    def arrive(time = Time.now.strftime('%H:%M'))
      login

      navigate_to_input_form

      # 出勤時間の入力
      work_field = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-6"]')
      @driver.action.send_keys(work_field, time).perform

      # 登録処理
      @driver.find_element(:xpath, '//input[@name="regbutton"]').click
    end

    def leave(time = Time.now.strftime('%H:%M'))
      login

      navigate_to_input_form

      # 退勤時間の入力
      work_field = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-9"]')
      @driver.action.send_keys(work_field, time).perform

      # 登録処理
      @driver.find_element(:xpath, '//input[@name="regbutton"]').click
    end

    def today
      login

      navigate_to_input_form

      date = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-0"]/nobr').text
      arrive_at = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-6"]/nobr').text
      leave_at = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-9"]/nobr').text

      today = Cxeed::Attendance.new date, arrive_at, leave_at

      today
    end
  end
end
