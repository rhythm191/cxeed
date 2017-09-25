# frozen_string_literal: true
require 'time'

module Cxeed
  class Attendance
    attr_accessor :date, :arrive_at, :leave_at

    def initialize(date, arrive_at, leave_at)
      @date = Time.parse(date, Time.now)
      @arrive_at = Time.parse(arrive_at, Time.now) unless arrive_at.empty?
      @leave_at = Time.parse(leave_at, Time.now) unless leave_at.empty?
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
