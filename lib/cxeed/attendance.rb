# frozen_string_literal: true
require 'time'

module Cxeed
  class Attendance
    attr_accessor :date, :arrive_at, :leave_at

    def initialize(date, arrive_at, leave_at)
      @date = Time.parse(date, Time.now)
      @arrive_at = parse_time(arrive_at)
      @leave_at = parse_time(leave_at)
    end

    def parse_time(time)
      if time.empty? || time == '  :  '
        nil
      else
        Time.parse(time, Time.now)
      end
    end


    def working_hour
      if @leave_at.nil? || @arrive_at.nil?
        0
      else
        (@leave_at - @arrive_at) / 3600
      end
    end

    def attendance_time
      "#{ @arrive_at&.strftime('%H:%M') } - #{ @leave_at&.strftime('%H:%M') } (#{ working_hour }) "
    end
  end
end
