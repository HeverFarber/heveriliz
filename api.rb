#!/usr/bin/env ruby
$LOAD_PATH << '.'

require 'sinatra'
require 'json'
require 'mail'

set :port, 8080

post "/InviteFriends" do
  data = JSON.parse(request.body.read)

  #puts data["from"]["email"], data["from"]["name"]
  Mail.send(data["from"], data["to"], "You've been invited to a secret place", "not really")

  "ok"
end