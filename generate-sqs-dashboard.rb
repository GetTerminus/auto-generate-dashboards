#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'erb'
require 'hcl/checker'

options = {output_file: '/tmp/generated-output.tmp'}
OptionParser.new do |opts|
  opts.banner = 'Usage: generate-service-overview [options]'

  opts.on('-a', '--convox-app-name APP_NAME', 'Convox app name') do |v|
    options[:app_name] = v
  end

  opts.on('--input-files x,y,z', Array, 'target terraform file') do |v|
    options[:input_files] = v
  end

	opts.on("-o", "--output-file TERRAFORM_TARGET_FILE", "target terraform file") do |v|
		options[:output_file] = v
	end
end.parse!

raise ArgumentError, 'Input files are required (define with --input-files)' unless options[:input_files]
raise ArgumentError, 'Missing convox app name  (define with -a)' unless options[:app_name]
raise ArgumentError, "Missing target Terraform file for output  (define with -o)" unless options[:output_file]

repo = options[:repo]
convox_app = options[:app_name]

domain_events = {}
sqs_queues = {}

options[:input_files].each do |file|
  config = HCL::Checker.parse(File.read(file))
  modules = config['module']

  domain_events.merge!(modules.select do |_, config|
    config['source']&.end_with?('modules/domain-event/subscription') ||
      config['source']&.match?(%r{modules/sqs(-fifo)?/declaration})
  end)

  next unless config['resource'] && config['resource']['aws_sqs_queue']

  sqs_queues.merge!(config['resource']['aws_sqs_queue'].select do |_name, config|
    config['name']
  end)
end

template = ERB.new(File.read(File.join(__dir__, 'templates', 'sqs-dashboard.erb')), nil, '-')

File.write(options[:output_file], template.result(binding))
