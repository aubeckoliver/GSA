import cds from '@sap/cds'
import nodemailer from 'nodemailer'

const LOG = cds.log('mail')

export default class MailService extends cds.Service {
  init() {
    const { credentials, from } = this.options
    const useSmtp = Boolean(credentials?.host)
    const transport = nodemailer.createTransport(useSmtp ? credentials : { jsonTransport: true })

    this.on('sendMail', async req => {
      const { to, subject, text } = req.data
      const info = await transport.sendMail({ from, to, subject, text })
      if (useSmtp) LOG.info(`Mail "${subject}" sent to ${to}`, info.messageId)
      else LOG.info(`Mail "${subject}" not sent to ${to} (no SMTP configured):\n${text}`)
    })

    return super.init()
  }
}
