on_worker_shutdown do
    puts "[#{$$}] Shutting down"
end

app do |env|
  puts "[#{$$}] A request is received. Sleeping for 10 seconds"
  sleep 10
  body = "Hello, World!\n"
  puts "[#{$$}] Responding"
  [
    200,
    {
      'Content-Type' => 'text/plain',
      'Content-Length' => body.length.to_s
    },
    [body]
  ]
end
