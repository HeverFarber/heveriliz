#!/usr/bin/env ruby
$LOAD_PATH << '.'

require 'sinatra'
require 'json'
require 'mail'
require 'user'

set :port, 8080

=begin
version > 1
request.body = {
  "from":"username",
  "to":["mail_friend1", mail_friend2],
  "custom_msg":"I am best friend...."}
=end
post "/api/:version/users/invite" do
  content_type :json
  data = JSON.parse(request.body.read)

  case params[:version]
    when "1"
      "api not supported in this version"
    else
      from = User.new(data["from"]).load
      if from.exists
        data["to"].each do |email|
          User.new(email).addRefer(from.email).save
        end

        if data["custom_msg"] == nil
          data["custom_msg"] = "My Msg"
        end

        Mail.send(from, data["to"], "You've been invited to a secret place", data["custom_msg"])

        {:status=>"ok",:msg=>"Invitations have been sent"}.to_json
      else
        {:status=>"error",:msg=>"You are not allowed to invite friends"}.to_json
      end
  end
end