require 'fileutils'

workers ENV.fetch('WEB_CONCURRENCY') { 1 }
threads ENV.fetch('MIN_THREADS') { 1 }.to_i, ENV.fetch('MAX_THREADS') { 1 }.to_i
if ENV['SOCKET']
  bind "unix://#{ENV['SOCKET']}"
else
  bind "tcp://#{ENV.fetch('BIND', '0.0.0.0')}:#{ENV.fetch('PORT', 3000)}"
end

before_fork do
  FileUtils.touch('/tmp/app-initialized')
end

on_worker_shutdown do
  puts "[#{$$}] Shutting down"
end

app do |env|
  case env['REQUEST_URI']
  when '/'
    body = "Hello, World!\n"
    [
      200,
      {
        'Content-Type' => 'text/plain',
        'Content-Length' => body.length.to_s
      },
      [body]
    ]
  when '/slow'
    puts "[#{$$}] A request is received at /slow. Sleeping for 10 seconds"
    sleep 10
    body = "Good morning, world!\n"
    puts "[#{$$}] Responding"
    [
      200,
      {
        'Content-Type' => 'text/plain',
        'Content-Length' => body.length.to_s
      },
      [body]
    ]
  else
    [
      404,
      {},
      []
    ]
  end
end
