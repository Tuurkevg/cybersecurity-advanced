#!/usr/sbin/nft -f

# Flush alle bestaande regels
flush ruleset

# Maak een nieuwe tabel aan voor filteren
table inet filter {
    # Chain voor binnenkomend verkeer
    chain input {
        type filter hook input priority 0; policy accept;

        # Toestaan van loopback verkeer
        iif "lo" accept

        # Toestaan van bestaande verbindingen en verwante verbindingen
        ct state established,related accept

        # Toestaan van inkomende DNS antwoorden
        ip saddr 172.30.1.4 udp sport 53 accept
        ip saddr 172.30.1.4 tcp sport 53 accept

        # Toestaan van inkomende HTTP(S) antwoorden
        ip saddr 172.30.2.10 tcp sport {80, 443} accept

        # Toestaan van verkeer van de router naar de client
        ip saddr 192.168.62.253 accept
    }

    # Chain voor uitgaand verkeer
    chain output {
        type filter hook output priority 0; policy accept;

        # Toestaan van uitgaande DNS-verzoeken
        ip daddr 172.30.1.4 udp dport 53 accept
        ip daddr 172.30.1.4 tcp dport 53 accept

        # Toestaan van uitgaand HTTP en HTTPS verkeer
        ip daddr 172.30.2.10 tcp dport {80, 443} accept

        # Toestaan van uitgaand verkeer naar de router
        ip daddr 192.168.62.253 accept
    }

    # Chain voor doorvoer verkeer
    chain forward {
        type filter hook forward priority 0; policy accept;


        # Toestaan van HTTP en HTTPS naar 172.30.2.10
        ip saddr 192.168.62.20 ip daddr 172.30.2.10 tcp dport {80, 443} accept

        # Toestaan van DNS naar 172.30.1.4
        ip saddr 192.168.62.20 ip daddr 172.30.1.4 tcp dport 53 accept
        ip saddr 192.168.62.20 ip daddr 172.30.1.4 udp dport 53 accept

        # Toestaan van verkeer van 192.168.62.20 naar de router 192.168.62.253
        ip saddr 192.168.62.20 ip daddr 192.168.62.253 accept

        # Blokkeer verkeer van 192.168.62.20 naar de netwerken 172.30.1.0, 172.30.2.0 en 172.30.3.0
        ip saddr 192.168.62.20 ip daddr 172.30.1.0/24 drop
        ip saddr 192.168.62.20 ip daddr 172.30.2.0/24 drop
        ip saddr 192.168.62.20 ip daddr 172.30.3.0/24 drop
    }
}
