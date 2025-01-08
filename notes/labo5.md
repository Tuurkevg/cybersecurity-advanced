# labo5 honeypods

## theorie

### Wat is een honeypot?

Een honeypot is een beveiligingsmechanisme dat zich voordoet als een aantrekkelijk doelwit voor aanvallers om hen te lokken en hun gedrag te analyseren.

### Welke typen honeypots bestaan er, en wat zijn hun functies en doelen?

Er zijn research honeypots (analyse van aanvallen) en production honeypots (afleiding van echte systemen); ze kunnen zich richten op laag-interactie (basismonitoring) of hoog-interactie (diepere analyse van aanvalleractiviteiten).

### Hoe verschillen honeypots van honey-/canarytokens?

Honeypots zijn fysieke of virtuele systemen die interactie met aanvallers toelaten, terwijl honeytokens data-elementen zijn die bij toegang of wijziging waarschuwen.

### Is Docker virtualisatie, emulatie of simulatie, en van welk type?

Docker is containerisatie, een lichte virtualisatievorm zonder type 1/2 onderscheid, die systeembestanden met de host deelt.

### Wat zijn enkele beveiligingsrisico's van Docker en is het veiliger dan virtuele machines?

Docker heeft risico’s zoals gedeelde kernelfuncties, waardoor virtuele machines soms veiliger zijn door hun volledige isolatie van de hostomgeving.

### Zou je Docker gebruiken om een honeypot in productie te implementeren? Waarom (niet)?

Nee, omdat Docker-omgevingen kernelfuncties delen en daardoor gevoeliger kunnen zijn voor aanvallen.

### Wat is een canary- of honeytoken?

Een canary- of honeytoken is een stukje data dat als lokaas dient en bij toegang of manipulatie waarschuwt voor mogelijke datalekken of inbraken.

## praktijk

### 1 Why is companyrouter, in this environment, an interesting device to configure with a SSH honeypot? What could be a good argument to NOT configure the router with a honeypot service?

Een argument tegen het configureren van de router met een honeypot is dat een kwetsbare SSH-honeypot op een essentiële router het netwerk kan blootstellen aan extra risico's als aanvallers de honeypot omzeilen of misbruiken.

### 2 pas aan naar ssh poort 2222

- ga in `/etc/ssh/sshd_config` poort verplaatsen naar 2222
- instlaleer dit om error te fixen:

```bash
sudo dnf install policycoreutils-python-utils
sudo semanage port -a -t ssh_port_t -p tcp 2222 
```

```sudo systemctl restart sshd```

### isntalleer de honypod

-docker compose file:

```yaml
version: '3'
services:
  cowrie:
    image: cowrie/cowrie:latest
    ports:
      - "22:2222"  # Maps port 22 on the host to port 2222 in the container
    environment:
      - COWRIE_LOGFILE=/cowrie/var/log/cowrie/cowrie.log
    volumes:
      - cowrie-data:/cowrie/var

volumes:
  cowrie-data:
    driver: local
```

--> docker-compose-yml

```bash
cd ~/home/vagrant
docker compose up -d
```

- bij errror doe `sudo systemctl restart docker`

`ssh root@192.168.62.253` passwoord = `password`
### Wat merk je op als je normaal probeert in te loggen op de router via SSH op poort 2222?

Je kunt normaal inloggen op de router, ervan uitgaande dat de juiste credentials worden gebruikt. De verbinding met de router functioneert zoals verwacht.

### Welke credentials werken? Vind je credentials die niet werken?

Veelgebruikte credentials zoals `root/password`.

### Krijg je een shell?

Ja, als je de juiste credentials invoert, krijg je een shell waar je commando's kunt uitvoeren. De shell functioneert zoals verwacht, net als bij een normale SSH-verbinding.

### Worden je commando's gelogd? Is het IP-adres van de SSH-client gelogd? Zo ja, waar?

Ja, de commando's die je uitvoert worden gelogd in Cowrie. Het IP-adres van de SSH-client wordt ook gelogd, je kan dit checken met ```docker logs XXX```

### Kan een aanvaller kwaadaardige dingen doen?

In de context van Cowrie kunnen aanvallers geen echte kwaadaardige acties uitvoeren, omdat het systeem geen echte wijzigingen aanbrengt. De honeypot simuleert interacties en logt alleen de commando's die worden geprobeerd.

### Worden de acties, met andere woorden de commando's, gelogd in een bestand? Welk bestand?

Ja, de acties en commando's worden gelogd in specifieke bestanden. In Cowrie zijn de belangrijkste logbestanden te vinden in `/cowrie/var/log/cowrie/cowrie.log` en de interactie-logs zijn te vinden in `/cowrie/var/log/cowrie/tty.log`. BIJ MIJ IS DIT GEWOON MET `DOCKER LOGS XXXX`

### Als je een ervaren hacker bent, hoe zou je kunnen realiseren dat dit geen normale omgeving is?

Een ervaren hacker zou kunnen opmerken dat de SSH-responsen ongewone patronen vertonen, zoals beperkte functionaliteit of onverwachte foutmeldingen. Daarnaast kunnen aangepaste prompts of waarschuwingen over monitoring de indruk wekken dat het een honeypot betreft. ZOALS WGET of andere asis commandos die defualt vaak geinstalleerd staan op een normale cumputer

## Voordelen en Nadelen van Docker als Dienst

### 1. Wat zijn enkele (minstens 2) voordelen van het uitvoeren van diensten (bijvoorbeeld Cowrie, maar het kan ook SQL Server zijn) met behulp van Docker?

- **Consistentie en portabiliteit**: Docker biedt een consistente omgeving voor applicaties, waardoor ze eenvoudig kunnen worden verplaatst tussen verschillende omgevingen.  
- **Schaalbaarheid en isolatie**: Docker maakt het eenvoudig om meerdere instanties van een dienst te schalen en biedt isolatie tussen verschillende containers, wat de beveiliging ten goede komt.

### 2. Wat zou een nadeel kunnen zijn? Geef minstens 1

- **Complexiteit in netwerkbeheer**: Het beheren van netwerken tussen containers kan complex zijn en kan leiden tot misconfiguraties die de beveiliging in gevaar brengen.

### 3. Wat wordt bedoeld met "Docker gebruikt een client-serverarchitectuur"?

- **Client-serverarchitectuur** betekent dat de Docker-client opdrachten verzendt naar de Docker-daemon, die de containers beheert en uitvoert.

### 4. Als welke gebruiker draait de Docker-daemon standaard?

- De Docker-daemon draait standaard als de gebruiker `root`.

### 5. Wat zou een voordeel kunnen zijn van het draaien van een honeypot in een virtuele machine in vergelijking met het draaien ervan in een container?

- **Verbeterde isolatie**: Virtuele machines bieden een sterkere isolatie van de host en andere services, wat het risico van een succesvolle aanval op de honeypot vermindert.
