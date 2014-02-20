#-------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved. Licensed under the MIT License.
#--------------------------------------------------------------------------

require "log4r"
module VagrantPlugins
  module HyperV
    module Action
      class MessageNotSuspended
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info("Machine is not suspended.")
          @app.call(env)
        end
      end
    end
  end
end
