#!/usr/bin/env ruby

require 'mandrill'

Excon.defaults[:ssl_verify_peer] = false

$mandrill = Mandrill::API.new 'key'

module Mail
  def Mail.send(from, to, subject , text)
    begin
      message = {"text"=>text,
                 "to"=> to.map { |mail| {"type"=> "to", "email"=> mail} },
                 "preserve_recipients"=>true,
                 "from_name"=>from["name"],
                 "from_email"=>from["email"],
                 "subject"=>subject}

      $mandrill.messages.send message, false, "Main Pool", nil

      return true
    rescue Mandrill::Error => e
      # Mandrill errors are thrown as exceptions
      puts "A mandrill error occurred: #{e.class} - #{e.message}"
      # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
      return false
    end
  end
end
