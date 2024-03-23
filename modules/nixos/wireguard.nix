# modules/wireguard.nix
{pkgs, ...}: {
  networking.wg-quick.interfaces = let
    server_ip = "174.61.230.151";
    server_public_key = "PUawZFlVz8vJ7wlY7wf1fSsrw+IQ2Kw/UZFtSIWB1nY=";
  in {
    wg0 = {
      # IP address of this machine in the *tunnel network*
      address = [
        "192.168.1.5/32"
      ];

      # To match firewall allowedUDPPorts (without this wg
      # uses random port numbers).
      listenPort = 51820;

      # Path to the private key file.
      privateKeyFile = "/home/tiec/TVWireguard.conf";

      peers = [
        {
          publicKey = "${server_public_key}";
          allowedIPs = [
            "0.0.0.0/0"
            "192.168.1.1/32"
            "192.168.1.5/32"
          ];
          endpoint = "${server_ip}:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
