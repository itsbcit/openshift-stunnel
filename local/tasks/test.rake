# frozen_string_literal: true

desc 'Test docker images'
task :test do
  puts '*** Testing images ***'.green
  $images.each do |image|
    puts "Running tests on #{image.base_tag}"
    sh "docker run --rm  -e STUNNEL_SERVICE=smoketest -e STUNNEL_ACCEPT=127.0.0.1 -e STUNNEL_CONNECT=127.0.0.1 #{image.base_tag} /bin/sh -c \"echo hello from #{image.base_tag}\""
  end
end
