# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"

config :logger, level: :debug, backends: [RingLogger]
config :nerves_network, :default,
  eth0: [
    ipv4_address_method: :dhcp
  ]  
config :nerves_firmware_ssh,
  authorized_keys: [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCGhWzD4l83uu6qbSUnDYH6k8Gk8lLYruqLFPNO/iMpSA6gKjYMif/q6iVYVdhI624S2Ymjo7xocC1oUgrjzyEzFWujzOfZOeDIxCySqiilfWIHiLkDbSlAO9ESlWOTBGK3OHbMN6DPANfHAy229XH+EE9JyBB1G1WMBsrpLjcKM3zKXILsFmKw9LUA/KbCG1LHQA/xTEY3+1RH1C/3h7+g1lwXyrTtBoslVcjjLryebBd+dih08mt7PW4oSsyOXqT0cK9250wZL5zUzYQmH3le0+Py9AYCC2nMeTyOSSUfQAjjXCZ+EsigEgHkFi7I5lsGZohUYpkajBG/Oi5U4mL5",
  ]
config :shoehorn,
  init: [:nerves_runtime, :nerves_network, :mdns, :nerves_firmware_ssh],
  app: Mix.Project.config()[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
