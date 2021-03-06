require 'spec_helper'

describe 'PHP 7.0 CI' do
  include_context 'ci' do
    let(:php_version) { '7.0' }
    let(:soe_packages) { Constants::PHP70_SOE_PACKAGES }
    let(:php_packages) { [
      'apache2',
      'php7.0',
      'php7.0-cli',
      'mariadb-client-10.2',
      'memcached',
      'php7.0-gd',
      'php7.0-dev',
      'php7.0-curl',
      'php7.0-mysql',
      'php-memcached',
      'php-soap',
      'php-pear'
    ] }
    let(:apache_version) { '2.4.18' }
    let(:apache_php_mod) { 'php7_module' }
    let(:ci_packages) { [ 'mariadb-server' ] }
    let(:ubuntu_version) { '16.04' }
  end

  before(:all) do
    image_name = "#{Constants::IMAGE_PREFIX}ci:php7.0"
    set :os, family: Constants::OS_FAMILY
    set :docker_image, get_docker_image_id(image_name)
  end
end
