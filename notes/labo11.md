# labo 11 CA

## theorie

- X.509 bepaal dformatie van de publik key certificaat. met all egegevens etc.
- Certificate Signing Request file voor request van certificaat signing .csr voor issueing
- What is SAN, Subject Alternative Name? dient voor alternatieve CN common names. Als jeverschillende domeinen wilt onderbrengen voor dezelfde service.
- What are Certificate chains and cross-certifications?
  - Een **certificate chain** is een reeks van certificaten die begint bij het eindcertificaat en eindigt bij het rootcertificaat, waarmee de geldigheid van het eindcertificaat wordt geverifieerd. **Cross-certificatie** is het proces waarbij twee verschillende certificaatautoriteiten (CA's) elkaar wederzijds vertrouwen door elkaars rootcertificaten te ondertekenen. Dit maakt het mogelijk dat certificaten van de ene CA vertrouwd worden door de klanten van de andere CA, wat interoperabiliteit tussen verschillende PKI-systemen mogelijk maakt.
- tls en ssl
  - SSL (Secure Sockets Layer) is een oudere cryptografische protocolversie, terwijl TLS (Transport Layer Security) de opvolger is die sterker en veiliger is. TLS is momenteel de standaard, met de versie TLS 1.2 en TLS 1.3 als de meest gebruikte. MD5 wordt niet meer gebruikt in de nieuwste versies van TLS, omdat het als kwetsbaar wordt beschouwd.
- letsencrypt? nadeel gratis of niet?
  - Let's Encrypt is een gratis Certificate Authority (CA) die SSL/TLS-certificaten levert voor websites om beveiligde HTTPS-verbindingen mogelijk te maken. Het kan problematisch lijken dat iedereen gratis certificaten kan verkrijgen, maar Let's Encrypt vereist strikte validatie van domeineigendom, wat voorkomt dat kwaadwillenden eenvoudig certificaten voor willekeurige domeinen kunnen verkrijgen. Het bevordert de algehele internetveiligheid door het gebruik van versleutelde verbindingen breed toegankelijk te maken.

ISP uitvoeren:

- find v3_req in /etc/ssl/openssl.cnf

```bash
[ v3_req ]

# Extensions to add to a certificate request

basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.cybersec.internal
DNS.2 = www.cybersec.internal
DNS.3 = services.cybersec.internal

[ v3_ca ]
```

- Create RSA private key in PEM format

```bash
openssl genrsa -out rootCA.key.pem -aes256 -passout pass:cyber
```

```bash
openssl rsa -in rootCA.key.pem -passin pass:cyber -text -noout
```

- Create self-signed root CA certificate

```bash
openssl req -config openssl.cnf -key rootCA.key.pem -new -x509 -days 365 -sha256 -extensions v3_ca -out rootCA.crt.pem -subj "/C=BE/ST=Vlaanderen/L=Gent/O=HoGent/OU=HoGent-Student/CN=CA-Arthurkegaatslagen" -passin pass:cyber
```

- parse the certificate

```bash
openssl x509 -in rootCA.crt.pem -text -noout
```

- Create a server key

```bash
openssl genrsa -out webserver.key.pem 2048
```

- Create a certificate signing request

```bash
openssl req -new -key webserver.key.pem -out webserver.csr.pem -subj "/C=BE/ST=Vlaanderen/L=Gent/O=HoGent/OU=WebServer/CN=*.cybersec.internal" -config openssl.cnf
```

- Sign the certificate

```bash
openssl x509 -req -in webserver.csr.pem -CA rootCA.crt.pem -CAkey rootCA.key.pem -CAcreateserial -out webserver.crt.pem -days 365 -sha256 -extfile openssl.cnf -extensions v3_req -passin pass:cyber
```

- verify the certificate

```bash
openssl x509 -in webserver.crt.pem -text -noout
```

- transfer these files to the webserver
  - webserver.crt.pem
  - webserver.key.pem
  - rootCA.crt.pem
- doet dit vanaf de isp in de home folder ca

```bash
scp webserver.crt.pem webserver.key.pem rootCA.crt.pem vagrant@172.30.2.10:/home/vagrant/
```

**op de web doe dit**

- `sudo yum install mod_ssl`
-voeg dit toe aan **/etc/httpd/conf/httpd.conf**
`LoadModule ssl_module modules/mod_ssl.so`

- edit dit bestand **/etc/httpd/conf.d/ssl.conf** en voeg dit toe

```bash
SSLCertificateFile /home/vagrant/certificates/webserver.crt.pem
SSLCertificateKeyFile /home/vagrant/certificates/webserver.key.pem
SSLCACertificateFile /home/vagrant/certificates/rootCA.crt.pem
```

- voer nu dit uit

```bash
sudo restorecon -R /etc/httpd/conf.d/certificates
sudo chcon -t httpd_config_t /etc/httpd/conf.d/certificates
```

- restart
  - `sudo systemctl restart httpd`
- zet root ca over naar kali red vm
  - `scp /home/vagrant/ca/rootCA.crt.pem kali@192.168.62.20:/home/kali/`

### extra vragen

- Een **private** key om certificaten te ondertekenen.
- Een **certificaat** om zichzelf te identificeren.
- Ja, een webserver gebruikt een **certificaat** om zichzelf te identificeren en veilige verbindingen te waarborgen.
- Ja, met bestandsnamen zoals .key (**private** key), .csr (request), en .crt (certificaat) kun je de functie makkelijk herkennen.
- Een **CSR** (Certificate Signing Request) is een bestand dat een publieke sleutel en identificatiegegevens bevat, bedoeld om een certificaat aan te vragen bij een CA.

- openssl x509 -in bestandsnaam.crt -text -noout

### vragen shizzel Webserver: Reverse Proxy

- What software is used for the reverse proxy?
  - Apache httpd server
- How is the reverse proxy configured?
  - In /etc/httpd/conf/httpd.conf

    ```bash
    LoadModule proxy_module modules/mod_proxy.so
    LoadModule proxy_http_module modules/mod_proxy_http.so

    ProxyPass "/services" "http://localhost:9200"
    ProxyPassReverse "/services" "http://localhost:9200"
    ProxyPass "/cmd" "http://localhost:8000/"
    ProxyPassReverse "/aaa" "http://localhost:8000/"
    ProxyPass "/assets" "http://localhost:8000/assets"
    ProxyPassReverse "/assets" "http://localhost:8000/assets"
    ProxyPass "/exec" "http://localhost:8000/exec"
    ProxyPassReverse "/exec" "http://localhost:8000/exec"
    ```

### **Services Running on /cmd and /services**

1. **Java Service (on `/cmd`)**:
   - **Service Command**: `/usr/bin/java -server -Xms128m -Xmx512m -jar /opt/insecurewebapp/app.jar`
   - **Programming Language**: **Java**
   - **Port**: **8000** (as shown by `lsof` command output)
   - **Required Files**:
     - `/opt/insecurewebapp/app.jar`

   #### **Command to identify this service**

   - `ps -p 647 -o pid,command`
   - `lsof -i :8000`

2. **Python Flask Service (on `/services`)**:
   - **Service Command**: `/usr/bin/python /opt/flask/app.py`
   - **Programming Language**: **Python** (Flask framework)
   - **Port**: **9200** (as shown by `lsof` command output)
   - **Required Files**:
     - `/opt/flask/app.py`

#### Command to identify this service

- `ps -p 646 -o pid,command`
- `ps -p 778 -o pid,command`
- `lsof -i :9200`

### extra: Create <https://services.cybersec.internal¶>

- Create a new virtual host in /etc/httpd/conf/httpd.conf at the end of the file

```bash
<VirtualHost *:443>
    ServerName services.cybersec.internal

    # SSL Configuration
    SSLEngine on
    SSLCertificateFile /etc/httpd/ssl/webserver.crt.pem
    SSLCertificateKeyFile /etc/httpd/ssl/webserver.key.pem

    # Redirect requests to /services
    ProxyPass / http://localhost/services/
    ProxyPassReverse / http://localhost/services/

    # Logging
    ErrorLog logs/services_error.log
    CustomLog logs/services_access.log combined
</VirtualHost>
```

- Restart the httpd service

```bash
service httpd restart
```

- op de dns server doe
`sudo vi /var/bind/cybersec.internal`
- voeg dit toe

```bash
services IN A   172.30.2.10
```

`sudo service named restart`
