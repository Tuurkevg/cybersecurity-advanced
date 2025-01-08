# labo 10 openvpn

## theorie

- Wat is een CA en hoe werkt het?

  - Een Certificate Authority (CA) is een vertrouwde derde partij die digitale certificaten uitgeeft. Deze certificaten worden gebruikt om de identiteit van een server, gebruiker of apparaat te verifiëren.
    Werking:

    - Een entiteit vraagt een certificaat aan bij de CA.
    - De CA valideert de identiteit van de aanvrager.
    - De CA geeft een digitaal certificaat uit, ondertekend met de private sleutel van de CA.
    - Browsers en systemen vertrouwen dit certificaat als het afkomstig is van een bekende CA.

- Waarom geen waarschuwing bij <https://chamilo.hogent.be>?

  - De server gebruikt een certificaat dat is uitgegeven door een vertrouwde CA.
  - De browser valideert het certificaat door:
        Te controleren of het certificaat door een vertrouwde CA is uitgegeven.
        Het certificaat niet is verlopen.
        Het domein (chamilo.hogent.be) overeenkomt met de informatie in het certificaat.
- Redenen om te kiezen:

  - IPsec: Voor site-to-site VPN’s of integratie met bestaande netwerkapparatuur.
    OpenVPN: Voor flexibiliteit, gebruiksgemak en ondersteuning van NAT.
- OSI-laag:

  - IPsec: Netwerklaag (laag 3).
    OpenVPN: Transportlaag (laag 4) en soms applicatielaag (laag 5/7).

- Is WireGuard vergelijkbaar met OpenVPN of IPsec?

  - WireGuard is vergelijkbaar met beide:

    - Met IPsec: Werkt ook op de netwerklaag, maar is eenvoudiger te configureren.
    Met OpenVPN: Geschikt voor toegang op afstand, maar sneller en lichter. Conclusie: WireGuard combineert de eenvoud van OpenVPN met de prestaties van IPsec.

- OpenVPN is een open-source alternatief dat dezelfde functionaliteit implementeert, maar op de transportlaag. Het belangrijkste idee is om een SSL-tunnel op te zetten (zoals bij HTTPS of SSH), maar in plaats van slechts één applicatie via deze tunnel te verzenden, wordt een compleet netwerk door de tunnel gestuurd. Het wordt een tunnel voor specifiek L3-netwerkverkeer via een L4-verbinding.

## labo

### CA en pki doen

- Step 2: Locate the Easy-RSA Executable
  - `sudo find / -name "easyrsa" 2>/dev/null`
- Step 3: Set Up the PKI Environment
  - `mkdir ~/easy-rsa-pki`
  - `cp -r /usr/share/easy-rsa/* ~/easy-rsa-pki/`
  - `cd ~/easy-rsa-pki`
- Step 4: Initialize the PKI
  - `./easyrsa init-pki`
  - `./easyrsa build-ca`

passphrase **Arthur**
domainname: **arthurgaatslagem.local**

- stapke 5 maak certs
  - `./easyrsa gen-req arthurgaatslagem.local nopass`
  - `./easyrsa sign-req server arthurgaatslagem.local`

- controleer met ssl in de map **/home/vagrant/easy-rsa-pki**:
  - `sudo openssl verify -CAfile pki/ca.crt pki/issued/arthurgaatslagem.local.crt`
  - ![alt text](image-6.png)
- stap 6 maak client certs aan
  - `./easyrsa gen-req remoteemployee nopass`
  - `./easyrsa sign-req client remoteemployee`

- controleer met ssl in de map **/home/vagrant/easy-rsa-pki**
  - `sudo openssl verify -CAfile pki/ca.crt pki/issued/remoteemployee.crt`
  - ![alt text](image-7.png)
- `./easyrsa gen-dh`

### openvpn server isntellen

- `sudo cp /usr/share/doc/openvpn/sample/sample-config-files/server.conf /etc/openvpn/server/`
  - /etc/openvpn/server/server.conf

```bash
server 10.8.0.0 255.255.255.0
push "route 172.30.1.0 255.255.255.0"
push "route 172.30.2.0 255.255.255.0"
push "route 172.30.3.0 255.255.255.0"
push "dhcp-option DNS 172.30.1.4"
push "dhcp-option DNS 8.8.8.8"
ca /home/vagrant/easy-rsa-pki/pki/ca.crt
cert /home/vagrant/easy-rsa-pki/pki/issued/arthurgaatslagem.local.crt
key /home/vagrant/easy-rsa-pki/pki/private/arthurgaatslagem.local.key
dh /home/vagrant/easy-rsa-pki/pki/dh.pem
dev tun
port 1194
proto udp
# zet dit uit ->;dev tap
```

### clien topenvpn isntellen op remote_employee

- `sudo dnf install openvpn -y`
- kopieer alle file snaar de remoteemployee van keys

    ```bash
    scp /home/vagrant/easy-rsa-pki/pki/ca.crt vagrant@172.10.10.123:/home/vagrant/ca.crt 
    scp /home/vagrant/easy-rsa-pki/pki/issued/remoteemployee.crt  vagrant@172.10.10.123:/home/vagrant/remoteemployee.crt
    scp /home/vagrant/easy-rsa-pki/pki/private/remoteemployee.key vagrant@172.10.10.123:/home/vagrant/remoteemployee.key
    ```

- /etc/openvpn/client/client.conf

  - ```bash
    ca /home/vagrant/ca.crt
    cert /home/vagrant/remoteemployee.crt
    key /home/vagrant/remoteemployee.key
    remote 192.168.62.253 1194
    '''

### demo

- company router **sudo openvpn /etc/openvpn/server/server.conf**
- remote_employee **sudo openvpn /etc/client/client.conf**
- op kali met ssh **sudo ettercap -Tq -i eth0 -M arp:remote /192.168.62.42// /192.168.62.253//**
- geef random username op en bij password op backspace drukken
- remoteployee **ping 172.30.1.4**
