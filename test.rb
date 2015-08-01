require 'thread'

queue = Queue.new

producer = Thread.new do
  counter = 0
  while true
    sleep rand(3)
    queue << counter
    counter += 1
  end
end

consumer = Thread.new do

  while true
    if queue.empty?
      sleep 2
      puts "sleep"
    else
      puts queue.pop
    end
  end
end

consumer.join