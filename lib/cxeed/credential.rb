# frozen_string_literal: true
require 'json'

module Cxeed
  class Credential

    attr_accessor :login_url, :company_code, :employee_code, :password

    CREDENTIAL_FILE_PATH = '~/.cxeed'

    def initialize(filename = CREDENTIAL_FILE_PATH)
      if File.exists?(File.expand_path(filename))
        json = open(File.expand_path(filename)) {|io| JSON.load(io) }
        @login_url = json['login_url']
        @company_code = json['company_code']
        @employee_code = json['employee_code']
        @password = json['password']
      end
    end

    def to_json
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
      hash.to_json
    end

    def store
      File.open(File.expand_path(CREDENTIAL_FILE_PATH), 'w', 0600) do |file|
        file.puts self.to_json
      end
    end
  end
end
