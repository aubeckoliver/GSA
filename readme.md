# Galactic Spacefarer Adventure

## Welcome emails

After a spacefarer is successfully created, a welcome email is sent to their `email` address via `mail` service ([srv/mail-service.js](srv/mail-service.js)).

Without SMTP credentials, mails are only logged. To send real mails, provide [nodemailer SMTP options](https://nodemailer.com/smtp/) as `cds.requires.mail.credentials`, e.g. in `.cdsrc-private.json` or via environment variables:

```sh
CDS_REQUIRES_MAIL_CREDENTIALS_HOST=smtp.example.com
CDS_REQUIRES_MAIL_CREDENTIALS_PORT=587
CDS_REQUIRES_MAIL_CREDENTIALS_AUTH_USER=...
CDS_REQUIRES_MAIL_CREDENTIALS_AUTH_PASS=...
```
