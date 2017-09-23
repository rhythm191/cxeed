# frozen_string_literal: true
require 'selenium-webdriver'

module Cxeed
  class Proxy
    def initialize(credential)
      @driver = Selenium::WebDriver.for :phantomjs
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
  end
end
