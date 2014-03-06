#-------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved. Licensed under the MIT License.
#--------------------------------------------------------------------------
require "vagrant"
require_relative "host_share/config"
module VagrantPlugins
  module HyperV
    class Config < Vagrant.plugin("2", :config)
      # If set to `true`, then Virtual Machine will be launched with a GUI.
      #
      # @return [Boolean]
      attr_accessor :gui, :guest
      attr_reader :host_share

      def host_config(&block)
        block.call(@host_share)
      end

      def finalize!
        @gui = nil if @gui == UNSET_VALUE
        @guest = nil if @guest == UNSET_VALUE
      end

      def initialize(region_specific=false)
        @gui = UNSET_VALUE
        @host_share = HostShare::Config.new
      end

      def validate(machine)
        errors = _detected_errors
        if (guest == UNSET_VALUE)
          errors << "Please mention the type of VM Guest"
        end
        if (guest == :linux && !host_share.valid_config?)
          errors << host_share.errors.flatten.join(" ")
        end
        { "HyperV" => errors }
      end

    end
  end
end