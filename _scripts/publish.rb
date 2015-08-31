require_relative 'helpers.rb'

# Login to the hub.
email = ENV['DOCKER_EMAIL']
user = ENV['DOCKER_USER']
pass = ENV['DOCKER_PASS']

login_cmd = "docker login -e=\"#{email}\" -u=\"#{user}\" -p=\"#{pass}\""

manifest = load_manifest
load_manifest.each do |path, container|
  image = get_image_name container
  break unless system! "docker push #{image}"
end
