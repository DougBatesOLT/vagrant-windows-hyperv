#---------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved. Licensed under the MIT License.
#--------------------------------------------------------------------------
require 'log4r'
require 'json'
require 'azure'

require 'vagrant/util/retryable'
require 'vagrant-azure/util/timer'

module VagrantPlugins
  module WinAzure
    module Action
      class RunInstance
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_azure::action::run_instance')
        end

        def call(env)
          config = env[:machine].provider_config

          params = {
            vm_name: config.vm_name,
            vm_user: config.vm_user,
            vm_password: config.vm_password,
            vm_image: config.vm_image,
            vm_location: config.vm_location,
            vm_affinity_group: config.vm_affinity_group
          }

          options = {
            storage_account_name: config.storage_acct_name,
            cloud_service_name: config.cloud_service_name,
            deployment_name: config.deployment_name,
            tcp_endpoints: config.tcp_endpoints,
            ssh_private_key_file: config.ssh_private_key_file,
            ssh_certificate_file: config.ssh_certificate_file,
            ssh_port: config.ssh_port,
            vm_size: config.vm_size,
            winrm_transport: config.winrm_transport,
            availability_set_name: config.availability_set_name
          }

          add_role = config.add_role

          env[:ui].info(params)
          env[:ui].info(options)
          env[:ui].info("Add Role? - #{add_role}")

          server = env[:azure_vm_service].create_virtual_machine(
            params, options, add_role
          )

          # TODO: Exceptio/Error Handling
          env[:machine].id = "#{server.vm_name}@#{server.cloud_service_name}"

          @app.call(env)
        end
      end
    end
  end
end
