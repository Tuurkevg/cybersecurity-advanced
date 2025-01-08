# labo 6 hardening

## theorie

### 1. Wat wordt bedoeld met de term "hardening"? Waarom zijn standaardinstellingen vaak niet goed?  

**Antwoord:** Hardening is het proces van het beveiligen van systemen door kwetsbaarheden te verminderen. Standaardinstellingen zijn vaak niet goed omdat ze kwetsbaarheden kunnen bevatten of niet zijn geconfigureerd voor specifieke beveiligingsvereisten.

---

### 2. Verklaar kort, zonder details, wat de volgende dingen zijn en waarom ze bestaan

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

### 6. Verklaar (geen details) wat threat modeling betekent  

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

run dt vanuit de **labo 6 map**!!
zie de files in passwd!
```ansible-playbook -i ../inventory.yml vraag2```

```yaml
---
- name: Fetch /etc/passwd files from all hosts
  hosts: all
  tasks:
    - name: Copy /etc/passwd to the controller node
      fetch:
        src: /etc/passwd
        dest: ./passwd_files/{{ inventory_hostname }}/
        flat: false
```

### 3 Create a playbook (or ad-hoc command) that creates the user "walt" with password Friday13th! on all Linux machines

zie /ansible/labo6/vraag3.vi
run in de map labo6!
```ansible-playbook -i ../inventory.yml vraag3.vi```

```yaml
- name: Create user walt on all Linux machines
  hosts: all
  become: yes
  tasks:
    - name: Ensure user "walt" exists with specified password
      user:
        name: walt
        password: "{{ 'Friday13th!' | password_hash('sha512') }}"
```

controle:
`cat /etc/passwd | grep walt`

### 4 Create a playbook (or ad-hoc command) that pulls all users that are allowed to log in on all Linux machines

vraag4 run in labo 6 map met
`ansible-playbook -i ../inventory.yml vraag4 --limit isprouter`

```yaml
---
- name: Get allowed login users from all hosts
  hosts: all
  tasks:
    - name: Extract users allowed to log in
      shell: "awk -F: '/bash|sh$/ {print $1}' /etc/passwd"
      register: login_users

    - name: Save allowed users to a file
      local_action:
        module: copy
        content: "{{ inventory_hostname }}:\n{{ login_users.stdout_lines | join('\n') }}\n\n"
        dest: ./allowed_users.log
        append: true
```

### vraag 5 Create a playbook (or ad-hoc command) that calculates the hash (md5sum for example) of a binary (for example the ss binary)

`ansible-playbook -i ../inventory.yml vraag5`
run dit ook weer in labo6 map isprouter zoals elke vraag btw

```yaml
---
- name: Calculate hash of the 'vi' binary
  hosts: all
  tasks:
    - name: Check if the 'vi' binary exists
      stat:
        path: /usr/bin/vi
      register: vi_stat

    - name: Calculate md5sum of the 'vi' binary
      command: md5sum /usr/bin/vi
      register: vi_md5
      when: vi_stat.stat.exists

    - name: Display the md5sum result
      debug:
        msg: "Hash of /usr/bin/vi: {{ vi_md5.stdout }}"
      when: vi_stat.stat.exists

    - name: Display message if binary is missing
      debug:
        msg: "'vi' binary is not found on this host."
      when: not vi_stat.stat.exists
```

### Create a playbook (or ad-hoc command) that copies a file (for example a txt file) from the ansible controller machine to all Linux machines

`ansible-playbook -i ../inventory.yml vraag6`
weer zoals altijd in labo 6 map op isprouter

```yaml
---
- name: Copy file from Ansible controller to all Linux machines
  hosts: all
  become: yes  # Ensure root privileges are used for this task
  tasks:
    - name: Copy the text file to the remote machine
      copy:
        src: /home/vagrant/ansible/labo6/copymij
        dest: /tmp/file.txt
        owner: root
        group: root
        mode: '0644'

```
