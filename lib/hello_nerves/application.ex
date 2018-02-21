defmodule HelloNerves.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      HelloNerves.Application.MdnsWorker
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  defmodule MdnsWorker do
    use GenServer

    def start_link(state) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
    end

    def init(initial_data) do
      ifname = "eth0"
      {:ok, _} = Registry.register(Nerves.Udhcpc, ifname, [])
      Mdns.Server.add_service(%Mdns.Server.Service{domain: "nerves.local", data: :ip, ttl: 60, type: :a})
      {:ok, initial_data}
    end

    def handle_info({Nerves.Udhcpc, :bound, info}, state) do
      Logger.debug("mdns dhcp bound #{inspect info}")
      setup_mdns(info)
      {:noreply, state}
    end
    def handle_info({Nerves.Udhcpc, :renew, info}, state) do
      Logger.debug("mdns dhcp renew #{inspect info}")
      setup_mdns(info)
      {:noreply, state}
    end

    def setup_mdns(info) do
      {:ok, ip} = :inet.parse_address(to_charlist(info[:ipv4_address]))
      Mdns.Server.set_ip(ip)
      Mdns.Server.start
    end
  end
end
