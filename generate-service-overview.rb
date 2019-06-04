#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'yaml'
require 'erb'
require 'digest'
require 'fileutils'

options = {mem_usage_opt_in: false, output_file: '/tmp/generated-output.tmp'}
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

  opts.on("-m", "--mem-usage-opt-in OPT_IN", "Opt in to memory usage monitor") do |v|
    v == 'true' ? options[:mem_usage_opt_in] = true : options[:mem_usage_opt_in] = v
  end

  opts.on("-p", "--pagerduty-team PAGERDUTY_TEAM", "Team to notify when monitor is triggered") do |v|
    options[:pagerduty_team] = v
  end 

end.parse!

raise ArgumentError, 'Missing convox app name  (define with -a)' unless options[:app_name]
raise ArgumentError, "Missing target Terraform file for output  (define with -o)" unless options[:output_file]
raise ArgumentError, "Invalid value for memory usage monitor opt in  (define with -m, valid values are: true)" unless [true, false].include?(options[:mem_usage_opt_in])
raise ArgumentError, "Pager Duty team must be present if memory usage opt in monitor is in use  (define with -p)" if options[:pagerduty_team].blank? && options[:mem_usage_opt_in] == true

repo = options[:repo]
convox_app = options[:app_name]
pagerduty_team = options[:pagerduty_team]
mem_usage_opt_in = options[:mem_usage_opt_in]

config = YAML.safe_load(File.read(options[:file]))

template = ERB.new(File.read(File.join(__dir__, 'templates', 'services-overview.erb')))

File.write(options[:output_file], template.result(binding))
