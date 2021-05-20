# frozen_string_literal: true

desc 'Test docker images'
task :test do
  puts '*** Testing images ***'.green
  $images.each do |image|
    puts "Running tests on #{image.build_tag}"
    sh "docker run --rm  -e STUNNEL_SERVICE=smoketest -e STUNNEL_ACCEPT=127.0.0.1 -e STUNNEL_CONNECT=127.0.0.1 #{image.build_tag} /bin/sh -c \"echo hello from #{image.build_tag}\""
  end
end
