
# Jump/Bastion Host

Een **Jump Host** of **Bastion Host** is een speciaal beveiligde server die wordt gebruikt om toegang te krijgen tot andere servers binnen een intern netwerk dat anders niet direct toegankelijk is vanaf het internet. Het fungeert als een tussenstation waar gebruikers eerst op inloggen om vervolgens verbinding te maken met andere interne systemen.

### Waarom gebruiken bedrijven een Jump/Bastion Host?
- **Beveiliging**: Door al het verkeer via één toegangsserver te leiden, kan het bedrijf de toegang tot interne systemen beter controleren en monitoren.
- **Netwerkisolatie**: Interne servers zijn niet direct toegankelijk vanaf het internet, wat het risico op aanvallen vermindert.
- **Logging en controle**: Alle verbindingen naar interne systemen verlopen via de Bastion Host, wat het eenvoudig maakt om de toegang te loggen en te beheren.

---

# Verschil tussen lokale en remote port forwarding met SSH

### Lokale port forwarding
- **Definitie**: Bij lokale port forwarding stuurt SSH een poort op je lokale machine door naar een poort op een externe server. Het verkeer lijkt voor je lokale machine afkomstig te zijn van een lokaal proces, maar wordt eigenlijk via de SSH-tunnel naar de externe server gestuurd.
- **Gebruiksscenario**: Stel dat je een interne bedrijfswebpagina wilt bezoeken die alleen toegankelijk is via het interne netwerk, maar je bent extern verbonden. Je kunt een SSH-tunnel opzetten naar een bastion host die toegang heeft tot dat interne netwerk.
  - **Voorbeeld**:  
    ```bash
    ssh -L 8080:intranet.local:80 user@bastion
    ```
    Dit stuurt je lokale poort `8080` door naar poort `80` van `intranet.local` via de bastion host.

### Remote port forwarding
- **Definitie**: Remote port forwarding doet het tegenovergestelde van lokale port forwarding: het stuurt een poort van de externe server door naar een poort op je lokale machine. Verkeer dat op de externe server binnenkomt, wordt naar je lokale machine gestuurd.
- **Gebruiksscenario**: Stel dat je een applicatie op je lokale machine hebt draaien (bijvoorbeeld een webserver) die toegankelijk moet zijn vanaf een externe server.
  - **Voorbeeld**:  
    ```bash
    ssh -R 8080:localhost:80 user@remote
    ```
    Dit maakt de lokale webserver op poort `80` toegankelijk via poort `8080` op de externe machine.

---

# SOCKS-protocol

Het **SOCKS-protocol** is een netwerkprotocol dat verkeer tussen een client en een server door een proxyserver kan sturen. SOCKS werkt op laag 5 van het OSI-model en ondersteunt verschillende soorten verkeer (zoals HTTP, HTTPS, en FTP).

### Gebruik van SOCKS met SSH
Met SSH kun je een dynamische SOCKS-proxy opzetten, waardoor je verkeer via een beveiligde tunnel kan sturen. Dit is nuttig als je bijvoorbeeld anoniem wilt browsen of je netwerkverkeer wilt beveiligen.

### Voorbeeld:
```bash
ssh -D 1080 user@server
```

```bash
Host companyrouter cr
    HostName 192.168.62.254
    User vagrant
    Port 22
    IdentityFile ~/.ssh/id_rsa
Host dns
    Hostname 172.30.0.4
    User vagrant
    Port 22
    ProxyJump cr
    IdentityFile ~/.ssh/id_rsa
Host web
    HostName 172.30.0.10
    User vagrant
    Port 22
    ProxyJump cr
    IdentityFile ~/.ssh/id_rsa
Host database db
        HostName 172.30.0.15
        User vagrant
        Port 22
        ProxyJump cr
        IdentityFile ~/.ssh/id_rsa
Host employee
        HostName 172.30.0.123
        User vagrant
        Port 22
        ProxyJump cr
        IdentityFile ~/.ssh/id_rsa
Host homerouter hr
        HostName 192.168.62.42
        User vagrant
        Port 22
        IdentityFile ~/.ssh/id_rsa
Host remote_employee re
        HostName 172.10.10.123
        User vagrant
        Port 22
        ProxyJump hr
        IdentityFile ~/.ssh/id_rsa
    ```

ssh -A vagrant@192.168.62.254
ssh-copy-id vagrant@172.30.0.4   # Kopieer de sleutel naar de DNS-server
ssh-copy-id vagrant@172.30.0.10  # Kopieer de sleutel naar de Web-server
ssh-copy-id vagrant@172.30.0.15  # Kopieer de sleutel naar de Database-server
ssh-copy-id vagrant@172.30.0.123 # Kopieer de sleutel naar de Employee-machine

```
## portforwarding dingetjes met ssh

### Database bypass met firewall aan op kali:

`ssh -L 8080:172.30.3.20:3306 user@192.168.62.253`
vervolgens nog 
`mysql -h 127.0.0.1 -P 8080 -u db_user -p`  

### Waarom is dit een interessante aanpak vanuit beveiligingsperspectief?
Het biedt een veilige manier om firewall-beperkingen te omzeilen zonder directe toegang te geven tot het interne netwerk.

### Wanneer zou je lokale port forwarding gebruiken?
Wanneer je vanaf je lokale machine toegang wilt tot een externe service die achter een firewall zit.

### Wanneer zou je remote port forwarding gebruiken?
Wanneer je een service op je lokale machine toegankelijk wilt maken voor een externe server of netwerk.

### Welke van de twee is vaker gebruikt in beveiliging?
Lokale port forwarding komt vaker voor in beveiligingsomgevingen.

### Waarom noemen sommigen SSH port forwarding een "poor man's VPN"?
Omdat het een eenvoudige, goedkope manier is om verkeer te versleutelen en te tunnelen, zonder de complexiteit van een volledige VPN.

#voorbeelden
## Voorbeeld 1: Gebruik port forwarding om de webpagina van de webserver te bekijken via de browser op je laptop:

### Voorbeeld 1: Gebruik port forwarding om de webpagina van de webserver te bekijken via de browser op je laptop:
run op eigen pc!!
```ssh -L 8080:172.30.2.10:80 user@192.168.62.253```

run op de webserver
```ssh -R 8080:172.30.2.10:80 ipvanwaarjewiltdatdiehetkanzienoppoort8080```

### optie met J om te hoppen (zie config ssh hierboven)
run op eigen pc
```ssh -J vagrant@192.168.62.253 vagrant@172.30.2.10```

