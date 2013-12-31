#-------------------------------------------------------------------------
# Copyright 2013 Microsoft Open Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
require "log4r"
require "timeout"

module VagrantPlugins
  module HyperV
    module Action
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReadGuestIP
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::hyperv::connection")
        end

        def call(env)
          env[:ui].info("Obtaining Machine's network Info.")
          env[:machine_ssh_info] = read_host_ip(env[:hyperv_connection], env[:machine])
          @app.call(env)
        end

        def read_host_ip(connection, machine)
          return nil if machine.id.nil?

          # Find the machine
          hyperv_machine = connection.find_vm_by_id(machine.id)
          if hyperv_machine.nil?
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          end
          # Get Network details from WMI Provider
          # Wait for 120 sec By then the machine should be ready
          host_ip = nil
          begin
            Timeout.timeout(120) do
            begin
              host_ip = hyperv_machine.ip_address
              sleep 2 if host_ip.nil?
              end while host_ip.nil?
            end
          rescue Timeout::Error
            @logger.info("Cannot find the IP address of the virtual machine")
          end
          return { host: host_ip } unless host_ip.nil?
        end
      end
    end
  end
end