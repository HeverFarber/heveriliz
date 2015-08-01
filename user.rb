#!/usr/bin/env ruby

class User
  def initialize(email)
    $email=email
    $refers=Array.new
    $exists = nil
  end

  def exists
    return $exists
  end

  def save
    # code to insert db, if user exists marge this attr with user db
    self
  end

  def load
    $fullname = "Hever Farber"
    $exists = true
    # code to select from db
    self
  end

  def addRefer(email)
    if !$refers.include?(email)
      $refers.push email
    end

    self
  end

  def email
    $email
  end

  def fullname
    $fullname
  end
end