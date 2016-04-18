#!/usr/bin/env ruby
#
# Sensu Handler: mailer
#
# This handler formats alerts as mails and sends them off to a pre-defined recipient.
#
# Copyright 2012 Pal-Kristian Hamre (https://github.com/pkhamre | http://twitter.com/pkhamre)
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

# Note: The default mailer config is fetched from the predefined json config file which is "mailer.json" or any other
#       file defiend using the "json_config" command line option. The mailing list could also be configured on a per client basis
#       by defining the "mail_to" attribute in the client config file. This will override the default mailing list where the
#       alerts are being routed to for that particular client.

require 'sensu-handler'
require 'mail'
require 'timeout'
require 'erubis'

# patch to fix Exim delivery_method: https://github.com/mikel/mail/pull/546
# #YELLOW
module ::Mail # rubocop:disable Style/ClassAndModuleChildren
  class Exim < Sendmail
    def self.call(path, arguments, _destinations, encoded_message)
      popen "#{path} #{arguments}" do |io|
        io.puts encoded_message.to_lf
        io.flush
      end
    end
  end
end

class Mailer < Sensu::Handler
  option :json_config,
         description: 'Config Name',
         short: '-j JsonConfig',
         long: '--json_config JsonConfig',
         required: false,
         default: 'mailer'

  option :template,
         description: 'Message template to use',
         short: '-t TemplateFile',
         long: '--template TemplateFile',
         required: false

  option :content_type,
         description: 'Content-type of message',
         short: '-c ContentType',
         long: '--content_type ContentType',
         required: false

  option :subject_prefix,
         description: 'Prefix message subjects with this string',
         short: '-s prefix',
         long: '--subject_prefix prefix',
         required: false

  def short_name
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def action_to_string
    @event['action'].eql?('resolve') ? 'RESOLVED' : 'ALERT'
  end

  def prefix_subject
    if config[:subject_prefix]
      config[:subject_prefix] + ' '
    elsif settings[config[:json_config]]['subject_prefix']
      settings[config[:json_config]]['subject_prefix'] + ' '
    else
      ''
    end
  end

  def status_to_string
    case @event['check']['status']
    when 0
      'OK'
    when 1
      'WARNING'
    when 2
      'CRITICAL'
    else
      'UNKNOWN'
    end
  end

  def parse_content_type
    use = if config[:content_type]
            config[:content_type]
          elsif @event['check']['content_type']
            @event['check']['content_type']
          elsif settings[config[:json_config]]['content_type']
            settings[config[:json_config]]['content_type']
          else
            'plain'
          end

    if use.casecmp('html') == 0
      'text/html; charset=UTF-8'
    else
      'text/plain; charset=ISO-8859-1'
    end
  end

  def build_mail_to_list
    json_config = config[:json_config]
    mail_to = @event['client']['mail_to'] || settings[json_config]['mail_to']
    if settings[json_config].key?('subscriptions')
      if @event['check']['subscribers']
        @event['check']['subscribers'].each do |sub|
          if settings[json_config]['subscriptions'].key?(sub)
            mail_to << ", #{settings[json_config]['subscriptions'][sub]['mail_to']}"
          end
        end
      end
      if @event['client']['subscriptions']
        @event['client']['subscriptions'].each do |sub|
          if settings[json_config]['subscriptions'].key?(sub)
            mail_to << ", #{settings[json_config]['subscriptions'][sub]['mail_to']}"
          end
        end
      end
    end
    mail_to
  end

  def message_template
    return config[:template] if config[:template]
    return @event['check']['template'] if @event['check']['template']
    return settings[config[:json_config]]['template'] if settings[config[:json_config]]['template']
    nil
  end

  def build_body
    json_config = config[:json_config]
    admin_gui = settings[json_config]['admin_gui'] || 'http://localhost:8080/'
    # try to redact passwords from output and command
    output = (@event['check']['output']).to_s.gsub(/(\s-p|\s-P|\s--password)(\s*\S+)/, '\1 <password omitted>')
    command = (@event['check']['command']).to_s.gsub(/(\s-p|\s-P|\s--password)(\s*\S+)/, '\1 <password omitted>')
    playbook = "Playbook:  #{@event['check']['playbook']}" if @event['check']['playbook']

    template = if message_template && File.readable?(message_template)
                 File.read(message_template)
               else
                 <<-BODY.gsub(/^\s+/, '')
        <%= output %>
        Admin GUI: <%= admin_gui %>\n
        Host: <%= @event['client']['name'] %>\n
        Timestamp: <%= Time.at(@event['check']['issued']) %>\n
        Address:  <%= @event['client']['address'] %>\n
        Check Name:  <%= @event['check']['name'] %>\n
        Command:  <%= command %>\n
        Status:  <%= status_to_string %>\n
        Occurrences:  <%= @event['occurrences'] %>\n
        <%= playbook %>
      BODY
               end
    eruby = Erubis::Eruby.new(template)
    eruby.result(binding)
  end

  def handle
    json_config = config[:json_config]
    body = build_body
    content_type = parse_content_type
    mail_to = build_mail_to_list
    mail_from = settings[json_config]['mail_from']
    reply_to = settings[json_config]['reply_to'] || mail_from

    delivery_method = settings[json_config]['delivery_method'] || 'smtp'
    smtp_address = settings[json_config]['smtp_address'] || 'localhost'
    smtp_port = settings[json_config]['smtp_port'] || '25'
    smtp_domain = settings[json_config]['smtp_domain'] || 'localhost.localdomain'

    smtp_username = settings[json_config]['smtp_username'] || nil
    smtp_password = settings[json_config]['smtp_password'] || nil
    smtp_authentication = settings[json_config]['smtp_authentication'] || :plain
    smtp_enable_starttls_auto = settings[json_config]['smtp_enable_starttls_auto'] == 'false' ? false : true

    timeout_interval = settings[json_config]['timeout'] || 10

    headers = {
      'X-Sensu-Host'        => (@event['client']['name']).to_s,
      'X-Sensu-Timestamp'   => Time.at(@event['check']['issued']).to_s,
      'X-Sensu-Address'     => (@event['client']['address']).to_s,
      'X-Sensu-Check-Name'  => (@event['check']['name']).to_s,
      'X-Sensu-Status'      => status_to_string.to_s,
      'X-Sensu-Occurrences' => (@event['occurrences']).to_s
    }

    subject = if @event['check']['notification'].nil?
                "#{prefix_subject}#{action_to_string} - #{short_name}: #{status_to_string}"
              else
                "#{prefix_subject}#{action_to_string} - #{short_name}: #{@event['check']['notification']}"
              end

    Mail.defaults do
      delivery_options = {
        address: smtp_address,
        port: smtp_port,
        domain: smtp_domain,
        openssl_verify_mode: 'none',
        enable_starttls_auto: smtp_enable_starttls_auto
      }

      unless smtp_username.nil?
        auth_options = {
          user_name: smtp_username,
          password: smtp_password,
          authentication: smtp_authentication
        }
        delivery_options.merge! auth_options
      end

      delivery_method delivery_method.intern, delivery_options
    end

    begin
      Timeout::timeout(timeout_interval) {
        Mail.deliver do
          to mail_to
          from mail_from
          reply_to reply_to
          subject subject
          body body
          headers headers
          content_type content_type
        end

        puts 'mail -- sent alert for ' + short_name + ' to ' + mail_to.to_s
      }
    rescue Timeout::Error
      puts 'mail -- timed out while attempting to ' + @event['action'] + ' an incident -- ' + short_name
    end
  end
end
