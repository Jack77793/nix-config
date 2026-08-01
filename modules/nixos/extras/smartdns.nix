{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.extras.smartdns.enable {
  services.smartdns = {
    enable = true;
    settings = {
      bind = "[::]:53";
      cache-checkpoint-time = 43200;
      cache-file = "/var/lib/smartdns/cache";
      cache-persist = true;
      cache-size = 65536;
      dualstack-ip-selection = true;
      dualstack-ip-selection-threshold = 20;
      log-level = "warn";
      log-num = 1;
      log-size = "128k";
      prefetch-domain = true;
      serve-expired = true;
      serve-expired-ttl = 21600;
      speed-check-mode = "tcp:443,ping";
      server = [
        "8.8.8.8 -group google -exclude-default-group"
        "8.8.4.4 -group google -exclude-default-group"
        "2001:4860:4860::8888 -group google -exclude-default-group"
        "2001:4860:4860::8844 -group google -exclude-default-group"
        "1.1.1.1 -group cloudflare -exclude-default-group"
        "1.0.0.1 -group cloudflare -exclude-default-group"
        "2606:4700:4700::1111 -group cloudflare -exclude-default-group"
        "2606:4700:4700::1001 -group cloudflare -exclude-default-group"
        "223.5.5.5 -group alidns -exclude-default-group"
        "223.6.6.6 -group alidns -exclude-default-group"
        "2400:3200::1 -group alidns -exclude-default-group"
        "2400:3200:baba::1 -group alidns -exclude-default-group"
        "119.29.29.29 -group dnspod -exclude-default-group"
        "2402:4e00:: -group dnspod -exclude-default-group"
        "101.101.101.101 -group twnic -exclude-default-group"
        "2001:de4::101 -group twnic -exclude-default-group"
      ];
      server-https = [
        "https://doh.pub/dns-query -group cn -exclude-default-group"
        "https://dns.twnic.tw/dns-query"
      ];
      server-http3 = [
        "h3://dns.google/dns-query"
        "h3://cloudflare-dns.com/dns-query"
        "h3://dns.alidns.com/dns-query -group cn -exclude-default-group"
      ];
      domain-set = [
        "-name cn -file /var/lib/smartdns/china.list"
        "-name ad -file /var/lib/smartdns/ads.list"
      ];
      address = [
        "/domain-set:ad/#"
      ];
      nameserver = [
        "/dns.google/google"
        "/cloudflare-dns.com/cloudflare"
        "/alidns.com/alidns"
        "/doh.pub/dnspod"
        "/twnic.tw/twnic"
        "/domain-set:cn/cn"
      ];
    };
  };

  services.resolved.settings.Resolve = {
    DNS = lib.mkForce [ "127.0.0.1" ];
    DNSStubListener = false;
  };

  systemd = {
    timers."updategeosite" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 07:30:00";
        Persistent = true;
        Unit = "updategeosite.service";
      };
    };
    services."updategeosite" = {
      path = with pkgs; [
        coreutils
        gnugrep
        wget
      ];
      script = ''
        set -euo pipefail
        tmpfile1=$(mktemp)
        wget -q -O - \
        "https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/direct-list.txt" \
        "https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/china-list.txt" | \
        grep -v '^[[:space:]]*$' | \
        sort -u > $tmpfile1 && \
        mv $tmpfile1 /var/lib/smartdns/china.list

        tmpfile2=$(mktemp)
        wget -q -O - \
        "https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/reject-list.txt" | \
        sort -u > $tmpfile2 && \
        mv $tmpfile2 /var/lib/smartdns/ads.list

        systemctl restart smartdns.service
      '';
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
      };
    };
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/smartdns"
  ];
}
