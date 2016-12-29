require 'config_plus/base'
require 'config_plus/version'

module ConfigPlus
  autoload :Config, 'config_plus/config'
  autoload :DefaultLoaderLogic, 'config_plus/default_loader_logic'
  autoload :Helper, 'config_plus/helper'
  autoload :Loader, 'config_plus/loader'
  autoload :Merger, 'config_plus/merger'
  autoload :Node, 'config_plus/node'
end
