module ShadowsocksRuby
  module Connections
    module UDP
      # (see TCP::LocalBackendConnection)
      class LocalBackendConnection < ShadowsocksRuby::Connections::ServerConnection

        def process_first_packet
          address_bin = packet_protocol.udp_receive_from_localbackend(-1)
          host, port = Util::parse_address_bin(address_bin)
          create_plexer(host, port, DestinationConnection)
          class << self
            alias process_hook process_other_packet
          end
        end

        # (see TCP::ClientConnection#process_hook)
        alias process_hook process_first_packet

        def process_other_packet
          data = packet_protocol.udp_receive_from_localbackend(-1)
          plexer.packet_protocol.udp_send_to_destination(data)
        end

        alias udp_receive_from_localbackend async_recv
        alias udp_send_to_localbackend send_data

      end
    end
  end
end