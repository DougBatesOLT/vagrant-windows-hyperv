#-------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved. Licensed under the MIT License.
#--------------------------------------------------------------------------
source 'https://rubygems.org'

# Specify your gem's dependencies in hyper-v.gemspec
gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  # gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git"

  gem "vagrant", :git => 'git://github.com/mitchellh/vagrant.git', :tag => 'v1.4.3'
end
