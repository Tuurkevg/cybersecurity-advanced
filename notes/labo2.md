
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
