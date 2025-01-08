# labo 8

## theorie

### 1. Wat is een SIEM?

**Antwoord:** SIEM staat voor Security Information and Event Management. Voorbeelden zijn Splunk, IBM QRadar en ArcSight, IT-beveiligingsteams om een gecentraliseerd overzicht te krijgen van de beveiligingsstatus van een organisatie. Een SIEM helpt bij het verzamelen, analyseren en beheren van beveiligingsgerelateerde gegevens in real time.

---

### 2. Wat is een SOC?

**Antwoord:** Een SOC (Security Operations Center) is een team dat verantwoordelijk is voor het monitoren en beheren van de beveiliging van een organisatie.

---

### 3. Wat wordt bedoeld met compliancy in termen van cybersecurity?

**Antwoord:** Compliancy verwijst naar het voldoen aan wettelijke en regelgevingseisen op het gebied van informatiebeveiliging en privacy.

---

### 4. Wat voor functies biedt Wazuh?

**Antwoord:** Wazuh biedt functies zoals loganalyse, integriteitsbewaking, incidentdetectie en kwetsbaarheidsscanning.

---

### 5. Wat is FIM?

**Antwoord:** FIM (File Integrity Monitoring) is een beveiligingsproces dat wijzigingen in bestanden en mappen detecteert en rapporteert.

---

### 6. Wat is Sysmon?

**Antwoord:** Sysmon (System Monitor) is een tool van Microsoft die gedetailleerde logboeken van systeemactiviteit genereert voor beveiligingsmonitoring en incidentrespons.

## labo

voer di tuit op fysieke laptop:
`ssh siem -L 8081:localhost:443`
surf naar <https://127.0.0.1:8081>
wazuh manager = 172.30.2.11
credetianals: `admin`:`OY*Ro7UD1kLlK+m6.lhpycxIUZj68sML`
wazuh versie `4.9.2`
logs checken van de agent `sudo tail -f /var/ossec/logs/ossec.log`

directories checken:
`sudo vi /var/ossec/etc/ossec.conf`
`<directories realtime="yes">/home/vagrant</directories>`
restart wazuh `sudo systemctl restart wazuh-agent`
check in de gui web FIM -> modified

### auditd logger

source: <https://wazuh.com/blog/monitoring-root-actions-on-linux-using-auditd-and-wazuh/>

- logs auditd `tail -f /var/log/audit/audit.log`
- herstart auditd" `sudo auditctl -R /etc/audit/rules.d/audit.rules`

- check nu de auditd logs van sudo " <https://127.0.0.1:8081/app/data-explorer/discover#?_q=(filters:!(),query:(language:kuery,query>:''))
**DEMO**
- doe `sudo systemctl status httpd` -> check erna de logs met de link hiebroven. (enkel sudo commandos worden gelogd voor veiligheid)
- uitleg automatisatie met autid, regels in deze file!!
  - `/etc/audit/rules.d/audit.rules`


### Wat is Regulatory Compliance?

- Regulatory Compliance betekent dat een organisatie voldoet aan wetten, regels en voorschriften die van toepassing zijn op haar bedrijfsactiviteiten,  zoals het beschermen van persoonsgegevens, financiële rapportage, of gezondheidsnormen.
  - Twee frameworks die verkend kunnen worden:

    - GDPR (General Data Protection Regulation): Europese wetgeving voor de bescherming van persoonsgegevens.
    - HIPAA (Health Insurance Portability and Accountability Act): Amerikaanse wetgeving voor de bescherming van gezondheidsinformatie

### notities les

wazuh installeren op ubuntu.
file integrity monitoring
ossec naam voor wazuh in bestanden

wazuh agent= vertelt wat er verstuurd moet worden naar de wazuh server
