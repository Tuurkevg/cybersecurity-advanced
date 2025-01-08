# labo 1 DNS

## Theorie

- installeren van kalilinu xom mee te experimenteren in fake internet network
- IP kalilinux = ```192.168.62.20```

## vragen

- **Netwerkdump maken via de CLI op een machine zonder GUI:**
  - `sudo tcpdump -w dumpfile.pcap`
- **SSH-verkeer uitsluiten:**
  - `sudo tcpdump not port 22`
- **Alleen HTTP-verkeer opnemen:**
  - `sudo tcpdump port 80`
  
- **In Wireshark kan een analist het volgende leren:**
  - Conversations: Overzicht van communicatie tussen IP-adressen, poorten, en hosts, inclusief details over verzonden en ontvangen pakketten.
  - Statistics: Gedetailleerde statistieken zoals datavolumes, netwerkgebruik, en tijdlijnen van communicatie.
  - Protocol Hierarchy: Een overzicht van gebruikte protocollen en hun verhoudingen binnen het netwerkverkeer.

- DNS-server informatie en acties:
  - Wanneer is het bedoeld en wat is een "normale" DNS-resolutie? Hoe voer je dit uit in de CLI?
    - `nslookup www.cybersec.internal`
  - Wat is een reverse lookup en hoe voer je het uit?
    - `nslookup 172.30.1.4`
  - Welke informatie kan worden opgehaald van een DNS-server?
    - **Domein-IP-koppelingen (A-records, AAAA-records).**
    - **Mailservers (MX-records).**
    - **Subdomeinen (CNAME, NS-records).**
    - **Service-informatie (SRV-records).**

## labo

### tcp dump help commando's

- maak deze alleen via de ocmpany router zoals in opdracht.
- `sudo tcpdump -i [interface] -w captured_traffic.pcap`

- **Downloaden** van file met scp van VM naar fysieke host of kali,..
- `scp dns:/home/vagrant/authorized_keys /home/arthur/Downloads/`
- **uplauden** naar vm vanaf de host
- `scp /home/arthur/Downloads/authorized_keys dns:/home/vagrant/`
- zorg ervoor dat alleen http verkeer van specifieke host gecaptured wordt met tcp dump:
- `sudo tcpdump -i [interface] port 80 and host [webserver-ip]`

### uitschakelen zonetransfer + testen

```bash
sudo vi /etc/bind/named.conf

allow-transfer { none; };  # voeg dit toe
```

- doe di top kali
dig axfr @172.30.1.4 cybersec.internal
- pas vervolgens dit aan

- op dns server
`sudo service named restart`

- doe dit op kali
 `dig axfr @172.30.1.4 cybersec.internal`
