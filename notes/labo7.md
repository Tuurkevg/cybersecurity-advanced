# LABO 7 BACKUPS

## theorie

- What different "rules" exist when talking about a backup strategy?
- What is the difference between a full vs an incremental backup? Give for both advantages and downsides.
- Why do some people state that "synchronisation with a cloud service (OneDrive, Dropbox, Google Drive) is not a synonym for backups"?
- When using a cloud storage to store backups, like OneDrive, you can assume they provide backups and maybe have a backup strategy in place. Why cyber security experts state it is still not enough to only store critical data on (this) one place? In other words why is putting 100% trust on a cloud provider a (potential) bad idea?

## 1. Regels voor een Backup-Strategie

- **3-2-1 Regel**:
  - Bewaar 3 kopieën van je data (1 primair, 2 backups), op 2 verschillende media, waarvan 1 op een externe locatie.
- **Regelmaat**:
  - Maak regelmatig backups (dagelijks, wekelijks, afhankelijk van hoe vaak data verandert).
- **Redundantie**:
  - Zorg voor meerdere lagen (lokaal én extern) om risico's te spreiden.
- **Test je backups**:
  - Controleer regelmatig of je data herstelbaar is.

## 2. Verschil tussen Full en Incremental Backups

### Full Backup

- **Voordelen**:
  - Complete kopie van alle data.
  - Herstel is eenvoudig omdat je maar één backup nodig hebt.
- **Nadelen**:
  - Duurt lang om te maken.
  - Neemt veel opslagruimte in beslag.

### Incremental Backup

- **Voordelen**:
  - Alleen wijzigingen sinds de laatste backup worden opgeslagen.
  - Sneller en vereist minder opslagruimte.
- **Nadelen**:
  - Herstellen duurt langer omdat meerdere backups nodig zijn.
  - Afhankelijk van vorige backups; verlies van één backup kan problemen veroorzaken.

## 3. Waarom Synchronisatie Geen Backup Is

- Synchronisatie (bijv. met Dropbox, Google Drive) kopieert wijzigingen in realtime.
- Als een bestand wordt gewist of beschadigd, wordt deze wijziging gesynchroniseerd naar alle locaties.
- Er is geen versiebeheer of bescherming tegen menselijke fouten of ransomware.

## 4. Risico’s van Volledige Vertrouwen op Cloudproviders

- **Dataverlies**:
  - Zelfs grote cloudproviders zijn niet immuun voor fouten zoals hardware-uitval of cyberaanvallen.
- **Lock-in risico**:
  - Geen toegang meer tot je account (bijv. door hacks, blokkades of faillissement) betekent dat je data onbereikbaar is.
- **Beveiligingslekken**:
  - Gevoelige data kan worden blootgesteld bij een datalek.
- **Geen volledige controle**:
  - Je bent afhankelijk van hun infrastructuur en beleid, wat kan veranderen.
  -

## labo

- name-all options. What do these options do? Why do you need them? Do you really need them? What happens without them?
- curl --remote-name-all <https://video.blender.org/download/videos/bf1f3fb5-b119-4f9f-9930-8e20e892b898-720.mp4> <https://www.gutenberg.org/ebooks/100.txt.utf-8> <https://www.gutenberg.org/ebooks/996.txt.utf-8> <https://upload.wikimedia.org/wikipedia/commons/4/40/Toreador_song_cleaned.ogg>
- De opties --location en --remote-name-all zijn bedoeld om het proces van downloaden via curl eenvoudiger en betrouwbaarder te maken, vooral als je meerdere bestanden tegelijk downloadt van URL's die mogelijk redirects hebben. Zonder deze opties kun je te maken krijgen met incomplete downloads of gedoe met bestandsnamen.

- **Database zal de backup bewaren de web de actieve files**

- instaleren van epel release voor borgbackup `sudo dnf install epel-release`
- `sudo dnf isntall borgbackup` op de webserver
- `apk add borgbackup` op de alpine database
- 'ssh-keygen -t rsa -b 4096 -C "vagrant@webserver"'
- 'ssh vagrant@172.30.1.15'
- `borg init --encryption=repokey vagrant@172.30.1.15:/home/vagrant/backups` op de webserver uitvoeren
- maak eerste backup met naam **first** `borg create vagrant@172.30.1.15:/home/vagrant/backups::first ~/important-files/`
- borg info `borg info  vagrant@172.30.1.15:/home/vagrant/backups`
- `borg create vagrant@172.30.1.15:/home/vagrant/backups::second ~/important-files/`
- toon de aangemaakte file **test.txt** `borg list  vagrant@172.30.1.15:/home/vagrant/backups::second`

- check de grote van de map met `du -sh --si .`
  - verschil met of zonder **--si** `Without --si: Uses binary units (powers of 1024, e.g., KiB, MiB).With --si: Uses decimal units (powers of 1000, e.g.,kB, M`
- documentatie borg **<https://borgbackup.readthedocs.io/en/stable/>**
- Wat zijn chunks?
  - Borg verdeelt bestanden in kleine data-eenheden genaamd chunks. Elke chunk krijgt een unieke hash (via een algoritme zoals SHA256).

### demo verwijder alles van web

- `rm --recursive --verbose important-files/`
- zorg ervoor dat 2 subfolders diep terug haald van backup ```borg extract vagrant@172.30.1.15:/home/vagrant/backups::first --strip-components 2```

- **automatisatie**

    ```bash
    sudo systemctl enable borg-backup.timer
    sudo systemctl start borg-backup.timer
    sudo systemctl status borg-backup.timer
    ```

    **geforceert laten uitvoeren** `sudo systemctl restart borg-backup.service`

- **FILES OP DE WEBSERVER OPGESLAGEN:**
  - `/etc/systemd/system/borg-backup.service`
  - `/etc/systemd/system/borg-backup.timer`
  - `/home/vagrant/backupscript.sh`
**logs van automatisatie**
`sudo journalctl -u borg-backup.service -f`
- Retentiebeleid

    Een retentiebeleid bepaalt hoe lang je verschillende soorten backups bewaart. Dit helpt om de opslagruimte efficiënt te gebruiken door niet teveel oude backups op te slaan.
- Borg compact Commando
    Het borg compact commando wordt gebruikt om je Borg repository op te schonen en de opslagruimte te optimaliseren. Wanneer je bijvoorbeeld veel kleine backups hebt gemaakt en oude data niet meer nodig is, kun je het borg compact commando gebruiken om deze ongebruikte data uit de repository te verwijderen.
- Grandfather*-Father-Son (GFS) Beleid

    Son (Dagelijks): Dagelijkse backups worden elke dag gemaakt.
    Father (Wekelijks): Van de dagelijkse backups wordt er elke week een geselecteerd en bewaard.
    Grandfather (Maandelijks): Van de wekelijkse backups wordt er elke maand een geselecteerd en bewaard.
