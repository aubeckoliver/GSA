import cds from '@sap/cds'

const FUEL_PER_DISTANCE_UNIT = 10
const FUEL_DISCOUNT_PERCENT_PER_SKILL_LEVEL = 5

export default class GalacticService extends cds.ApplicationService {
  async init() {
    const mail = await cds.connect.to('mail')
    const { Spacefarers, UserCapabilities } = this.entities
    const { Planets, Locations } = cds.entities('galactic')
    const { stardustCollection: stardustElement, wormholeNavigationSkill: navSkillElement } = Spacefarers.elements
    const [minStardust] = stardustElement['@assert.range']
    const defaultStardust = stardustElement.default?.val ?? minStardust
    const [minNavigationSkill, maxNavigationSkill] = navSkillElement['@assert.range']
    const defaultNavigationSkill = navSkillElement.default?.val ?? minNavigationSkill

    this.before(['CREATE', 'UPDATE'], Spacefarers, req => {
      const planet = req.user.attr?.planet
      if (!planet) return req.reject(403, 'No planet assigned to your user')

      const target = req.data.originPlanet_name
      if (req.event === 'CREATE' || target !== undefined) {
        if (target !== planet) {
          return req.reject(403, `You may only manage spacefarers from planet ${planet}`, 'originPlanet_name')
        }
      }
    })

    this.before(['CREATE', 'UPDATE'], Spacefarers, async req => {
      if (req.errors) return

      let data = req.data
      if (req.event === 'UPDATE') {
        const relevant = ['stardustCollection', 'wormholeNavigationSkill', 'originPlanet_name', 'targetLocation_ID']

        if (!data.ID || !relevant.some(element => element in data)) return
        const current = await SELECT.one.from(cds.entities('galactic').Spacefarers, data.ID)

        if (!current) return
        const changed = relevant.some(element => element in data && String(data[element]) !== String(current[element]))
        
        if (!changed) return
        data = { ...current, ...data }
      }

      const stardust = Number(data.stardustCollection ?? defaultStardust)
      const skill = Number(data.wormholeNavigationSkill ?? defaultNavigationSkill)

      if (!Number.isInteger(stardust)) {
        req.error(400, 'Stardust collection must be a whole number', 'stardustCollection')
      }
      if (!Number.isInteger(skill)) {
        req.error(400, 'Wormhole navigation skill must be a whole number', 'wormholeNavigationSkill')
      }
      if (req.errors) return

      const origin = await SELECT.one.from(Planets, data.originPlanet_name)
      const target = await SELECT.one.from(Locations, data.targetLocation_ID)
      if (!origin || !target) return
      const distance = Math.hypot(
        Number(target.location_x ?? 0) - Number(origin.location_x ?? 0),
        Number(target.location_y ?? 0) - Number(origin.location_y ?? 0)
      )

      const discountPercent = FUEL_DISCOUNT_PERCENT_PER_SKILL_LEVEL * (skill - minNavigationSkill)
      const requiredFuel = Math.ceil((distance * FUEL_PER_DISTANCE_UNIT * (100 - discountPercent)) / 100)
      if (stardust < requiredFuel) {
        return req.error(
          400,
          `Not enough stardust for the journey to target location ${target.name}: ${requiredFuel} needed, ${stardust} available`,
          'stardustCollection'
        )
      }
    })

    this.on('READ', UserCapabilities, req => ({
      manageSpacefarersHidden: !req.user.is('SpacefarerAdmin')
    }))

    this.after('CREATE', Spacefarers, async (_, req) => {
      const { firstName, lastName, email, originPlanet_name: planet, targetLocation_ID } = req.data
      const target = await SELECT.one.from(Locations, targetLocation_ID).columns('name')
      const destination = target?.name ?? 'your destination'

      await mail.send('sendMail', {
        to: email,
        subject: `Welcome aboard, ${firstName}! Your cosmic journey begins`,
        text:
          `Greetings, ${firstName} ${lastName}!\n\n` +
          `Congratulations on launching from ${planet}! You are now officially a spacefarer, ` +
          `headed to ${destination}.\n\n` +
          `Wishing you safe travel and clear skies on your journey among the stars.\n\n` +
          `Galactic Spacefarer Adventure`
      })
    })

    return super.init()
  }
}
