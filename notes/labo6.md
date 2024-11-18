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


### voor de ssh keys programma
`ansible-galaxy collection install ansible.posix`

### 1. Ad-hoc Command to Check Date Consistency
```isprouter:~/ansible$ ansible all -i inventory.yml -m command -a "date"```

### 2.  Playbook to Pull /etc/passwd Files


### 3 Create a playbook (or ad-hoc command) that creates the user "walt" with password Friday13th! on all Linux machines.
zie /ansible/labo6/vraag3.vi
```
- name: Create user walt on all Linux machines
  hosts: all
  become: yes
  tasks:
    - name: Ensure user "walt" exists with specified password
      user:
        name: walt
        password: "{{ 'Friday13th!' | password_hash('sha512') }}"
        ```