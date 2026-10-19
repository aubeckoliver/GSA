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

## Spacefarers UI

A Fiori elements List Report ([app/spacefarers](app/spacefarers)) lists spacefarers with their stardust collection and spacesuit color.

Run it locally:

```sh
npm install
cds deploy
npm run watch-spacefarers
```

For test, use one of these mocked users (empty password):

| User      | Role             | Planet |
| --------- | ---------------- | ------ |
| `viewer`  | SpacefarerViewer | Earth  |
| `admin`   | SpacefarerAdmin  | Earth  |
| `martian` | SpacefarerViewer | Mars   |
