# labo 6 hardening

## theorie

### 1. Wat wordt bedoeld met de term "hardening"? Waarom zijn standaardinstellingen vaak niet goed?  
**Antwoord:** Hardening is het proces van het beveiligen van systemen door kwetsbaarheden te verminderen. Standaardinstellingen zijn vaak niet goed omdat ze kwetsbaarheden kunnen bevatten of niet zijn geconfigureerd voor specifieke beveiligingsvereisten.

---

### 2. Verklaar kort, zonder details, wat de volgende dingen zijn en waarom ze bestaan:
- **CIS Benchmark:**  
  Richtlijnen voor best practices om systemen te beveiligen. Bestaat om consistentie en veiligheid te waarborgen.
  
- **OpenSCAP:**  
  Een open-source framework voor compliance-beoordeling en beveiligingsautomatisering. Bestaat om systemen te evalueren op beveiligingsbeleid.
  
- **Lynis:**  
  Een beveiligingsaudit-tool voor Unix-achtige systemen. Bestaat om beveiligingsrisico's te identificeren.
  
- **Microsoft Security Compliance Toolkit:**  
  Een set tools voor het beheren van beveiligingsinstellingen. Bestaat om organisaties te helpen bij het naleven van beveiligingsstandaarden.
  
- **Docker Bench:**  
  Een script om de veiligheid van Docker-installaties te beoordelen. Bestaat om best practices voor containerbeveiliging te waarborgen.
  
- **Maester:**  
  Een tool voor beveiligingsautomatisering en compliance-controle. Bestaat om het beheer van beveiligingsconfiguraties te vergemakkelijken.
  
- **dev-sec.io:**  
  Een community die beveiligingsrichtlijnen en tools ontwikkelt voor DevOps. Bestaat om veiligheid in ontwikkelprocessen te integreren.

---

### 3. Wat is OpenSCAP? (Geen details)  
**Antwoord:** Een framework voor compliance-beoordeling en beveiligingsautomatisering.

---

### 4. Wat is Lynis? (Geen details)  
**Antwoord:** Een beveiligingsaudit-tool voor Unix-achtige systemen.

---

### 5. Wat wordt bedoeld met threat hunting?  
**Antwoord:** Het proactief zoeken naar tekenen van aanvallen in netwerken en systemen.

---

### 6. Verklaar (geen details) wat threat modeling betekent.  
**Antwoord:** Een proces om potentiële beveiligingsbedreigingen en -kwetsbaarheden in een systeem te identificeren.

---

### 7. Waarom noemen sommige mensen Ansible een tool die geschikt is voor zowel hardening als hunting?  
**Antwoord:** Ansible kan worden gebruikt voor automatisering van beveiligingsconfiguraties (hardening) en voor het uitvoeren van incidentrespons en monitoring (hunting).


## labo


### Start of by creating a separate SSH keypair specifically for ansible (we recommend to also create a separate ansible user) and copy over the correct (public or private?) key to the remote locations (which file holds this key on the remote machine?). You can use the vagrant user the first time for creating the ansible user if you do not want to do this manually.


`ssh-keygen -t rsa -b 4096 -C "ansible@example.com" -f ~/.ssh/ansible_key`
`sudo adduser ansible`