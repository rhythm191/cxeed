# frozen_string_literal: true
require 'selenium-webdriver'

module Cxeed
  class Proxy
    BACKSPACE = "\ue003".freeze

    def initialize(credential, verbose: false, save_screenshot: false)
      caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions': {args: %i(--headless --disable-gpu window-size=1920,1080)})
      @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

      @credential = credential
      @verbose = verbose
      @save_screenshot = save_screenshot
    end

    def login
      puts '* start login' if @verbose

      @driver.navigate.to(@credential.login_url)

      puts "* at #{ @driver.current_url }" if @verbose
      save_screenshot

      # 会社コード入力
      @driver.find_element(:name, 'DataSource').send_keys(@credential.company_code)
      # 個人コード入力
      @driver.find_element(:name, 'LoginID').send_keys(@credential.employee_code)
      # パスワード入力
      @driver.find_element(:name, 'PassWord').send_keys(@credential.password)


      puts "* input DataSource: #{ @driver.find_element(:name, 'DataSource').attribute('value')}" if @verbose
      puts "* input login id: #{ @driver.find_element(:name, 'LoginID').attribute('value')}" if @verbose
      puts "* input password: #{ @driver.find_element(:name, 'PassWord').attribute('value')}" if @verbose
      save_screenshot

      # ログイン処理
      @driver.find_element(:xpath, '//td[@class="loginBtn"]/a').click

      puts "* after click login page: #{ @driver.current_url }" if @verbose
      save_screenshot
    end

    def login_test
      login

      @driver.current_url
    end

    def navigate_to_input_form
      puts "* start navigate input form: frame2=#{ @driver.find_element(:name, 'FRAME2').attribute('src') }" if @verbose
      save_screenshot

      # frameの指定
      @driver.switch_to.frame @driver.find_element(id: 'FRAME1')
      # 勤務データ入力遷移
      @driver.find_element(:xpath, '//a[@title="勤務データ入力"]').click

      # 一旦main documentに戻る
      @driver.switch_to.default_content
      # frameの指定
      @driver.switch_to.frame @driver.find_element(name: 'FRAME2')

      puts "* finish navigate input form: #{ @driver.current_url }" if @verbose
      save_screenshot
    end

    # 引数の日付の入力画面に遷移する
    def open_date(date)
      puts "* start open date command: #{ @driver.current_url }: #{ @driver.find_element(:class, 'cxCmnTitleStr').text }" if @verbose

      # 処理期間の入力
      @driver.find_element(:xpath, '//input[@name="StartYMD"]').send_keys(BACKSPACE * 8)
      @driver.find_element(:xpath, '//input[@name="StartYMD"]').send_keys(date.strftime('%Y%m%d'))
      @driver.find_element(:xpath, '//input[@name="EndYMD"]').send_keys(BACKSPACE * 8)
      @driver.find_element(:xpath, '//input[@name="EndYMD"]').send_keys(date.strftime('%Y%m%d'))


      puts "* input start date: #{  @driver.find_element(:xpath, '//input[@name="StartYMD"]').attribute('value') }" if @verbose
      puts "* input end date: #{  @driver.find_element(:xpath, '//input[@name="EndYMD"]').attribute('value') }" if @verbose
      save_screenshot

      # 検索
      @driver.find_element(:xpath, '//input[@name="srchbutton"]').click

      puts "* after click search button: #{ @driver.current_url }" if @verbose
      save_screenshot
    end

    def arrive(time = Time.now.strftime('%H:%M'), date = Time.now)
      login

      navigate_to_input_form

      open_date(date)

      # 出勤時間の入力
      work_field = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-6"]')
      @driver.action.send_keys(work_field, time).perform
      save_screenshot

      # 登録処理
      @driver.find_element(:xpath, '//input[@name="regbutton"]').click

      puts "* after click register button: #{ @driver.current_url }" if @verbose
      save_screenshot
    end

    def leave(time = Time.now.strftime('%H:%M'), date = Time.now)
      login

      navigate_to_input_form

      open_date(date)

      # 退勤時間の入力
      work_field = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-9"]')
      @driver.action.send_keys(work_field, time).perform
      save_screenshot

      # 登録処理
      @driver.find_element(:xpath, '//input[@name="regbutton"]').click

      puts "* after click register button: #{ @driver.current_url }" if @verbose
      save_screenshot
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

    def day_attendance(day)
      login

      navigate_to_input_form

      # 日付の整形
      day_str = DateTime.parse(day).strftime('%Y%m%d')

      # 処理期間の入力
      @driver.find_element(:xpath, '//input[@name="StartYMD"]').send_keys(BACKSPACE * 8)
      @driver.find_element(:xpath, '//input[@name="StartYMD"]').send_keys(day_str)
      @driver.find_element(:xpath, '//input[@name="EndYMD"]').send_keys(BACKSPACE * 8)
      @driver.find_element(:xpath, '//input[@name="EndYMD"]').send_keys(day_str)

      # 検索
      @driver.find_element(:xpath, '//input[@name="srchbutton"]').click


      date = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-0"]/nobr').text
      arrive_at = @driver.find_element(:xpath, '//td[@id="grdXyw1100G-rc-0-6"]/nobr').text
      leave_at = @driver.find_element(:xpath,  '//td[@id="grdXyw1100G-rc-0-9"]/nobr').text

      Cxeed::Attendance.new date, arrive_at, leave_at
    end

    private

    def puts(output_string)
      puts "* #{ output_string }" if @verbose
    end

    def frame_source(frame_name)
      @driver.find_element(:name, frame_name).attribute('src')
    end

    def save_screenshot
      @driver.save_screenshot("./cxeed_#{ Time.now.strftime('%Y%m%d%H%M%S%L') }.png") if @save_screenshot
    end

  end
end
