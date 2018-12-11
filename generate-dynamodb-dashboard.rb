#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'erb'
require 'hcl/checker'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: generate-service-overview [options]'

  opts.on('-a', '--convox-app-name APP_NAME', 'Convox app name') do |v|
    options[:app_name] = v
  end

  opts.on('--input-files x,y,z', Array, 'target terraform file') do |v|
    options[:input_files] = v
  end
end.parse!

raise ArgumentError, 'Input files are required (define with --input-files)' unless options[:input_files]
raise ArgumentError, 'Missing convox app name  (define with -a)' unless options[:app_name]

repo = options[:repo]
convox_app = options[:app_name]

module_tables = {}
resource_tables = {}

options[:input_files].each do |file|
  config = HCL::Checker.parse(File.read(file))
  modules = config['module']

  module_tables.merge!(modules.select do |_, config|
    config['source']&.include?('dynamodb')
  end)

  resource_tables.merge!(config["resource"]["aws_dynamodb_table"] || {})
end

template = ERB.new(File.read(File.join(__dir__, 'templates', 'dynamodb-dashboard.erb')), nil, '-')

File.write('/tmp/generated-output.tmp', template.result(binding))
