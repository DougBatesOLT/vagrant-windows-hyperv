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

require "debugger"
require "log4r"
module VagrantPlugins
  module HyperV
    module Action
      class Import
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::hyperv::connection")
        end

        def call(env)
          box_directory = env[:machine].box.directory.to_s
          path = Pathname.new(box_directory.to_s + '/Virtual Machines')
          config_path = ""
          path.each_child do |f|
            config_path = f.to_s if f.extname.downcase == ".xml"
          end
          options = {
            :xml_path => config_path,
            :root_folder => box_directory,
            :need_unique_id => true
          }
          env[:ui].info "Importing a Hyper-V instance"
          begin
            server = env[:hyperv_connection].import(options)
          # TODO: Handle exception from WMIProvider
          rescue => e
            # Raise the exception
          end
          env[:machine].id = server.id
          @app.call(env)
        end
      end
    end
  end
end