#!/usr/bin/env ruby

require 'mandrill'
require 'thread'

Excon.defaults[:ssl_verify_peer] = false

$mandrill = Mandrill::API.new 'TNYvuLR_xCXZg4L_-mKyfQ'
$mailQueue = Queue.new

module Mail
  # Params = from:User, to:Array (of emails), subject:String, text:String
  def Mail.send(from, to, subject , text)
    message = {"text"=>text,
               "to"=> to.map { |mail| {"type"=> "to", "email"=> mail} },
               "preserve_recipients"=>true,
               "from_name"=>from.fullname,
               "from_email"=>from.email,
               "subject"=>subject}

    $mailQueue << message
  end
end

Thread.new do
  while true
    if $mailQueue.empty?
      sleep 1
    else
      begin
        $mandrill.messages.send $mailQueue.pop, false, "Main Pool", nil
      rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        puts "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
        return false
      end
    end
  end
end
