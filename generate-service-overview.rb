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

	opts.on("-f", "--convox-file CONVOX_FILE_NAME", "Convox file to parse for information (default: docker-compose.convox.yml)") do |v|
		options[:file] = v
	end

	opts.on("-o", "--output-file TERRAFORM_TARGET_FILE", "target terraform file") do |v|
		options[:output_file] = v
	end
end.parse!

raise ArgumentError, 'Missing convox app name  (define with -a)' unless options[:app_name]
raise ArgumentError, "Missing target Terraform file for output  (define with -o)" unless options[:output_file]

repo = options[:repo]
convox_app = options[:app_name]

config = YAML.safe_load(File.read(options[:file]))

template = ERB.new(File.read(File.join(__dir__, 'templates', 'services-overview.erb')), nil, '-')

File.write(options[:output_file], template.result(binding))
