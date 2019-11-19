workers ENV.fetch('WEB_CONCURRENCY') { 1 }
threads ENV.fetch('MIN_THREADS') { 1 }.to_i, ENV.fetch('MAX_THREADS') { 1 }.to_i
if ENV['SOCKET']
  bind "unix://#{ENV['SOCKET']}"
else
  bind "tcp://#{ENV.fetch('BIND', '0.0.0.0')}:#{ENV.fetch('PORT', 3000)}"
end

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
