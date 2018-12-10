#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'yaml'
require 'erb'
require 'digest'
require 'fileutils'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: generate-service-overview [options]'

  opts.on('-a', '--convox-app-name APP_NAME', 'Convox app name') do |v|
    options[:app_name] = v
  end
end.parse!

raise ArgumentError, 'Missing convox app name  (define with -a)' unless options[:app_name]

repo = options[:repo]
convox_app = options[:app_name]

config = YAML.safe_load(File.read('/tmp/input-file.tmp'))

template = ERB.new(File.read(File.join(__dir__, 'templates', 'services-overview.erb')))

File.write('/tmp/generated-output.tmp', template.result(binding))
