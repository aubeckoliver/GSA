import cds from '@sap/cds'

const FUEL_PER_DISTANCE_UNIT = 10
const FUEL_DISCOUNT_PERCENT_PER_SKILL_LEVEL = 5

export default class GalacticService extends cds.ApplicationService {
  init() {
    const { Spacefarers } = this.entities
    const { Planets, Positions } = cds.entities('galactic')
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
          return req.reject(403, `You may only manage spacefarers from planet ${planet}`)
        }
      }
    })

    this.before('CREATE', Spacefarers, async req => {
      if (req.errors) return

      const data = req.data
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
      const target = await SELECT.one.from(Positions, data.targetPosition_ID)

      const distance = Math.hypot(
        Number(target.location_x ?? 0) - Number(origin.location_x ?? 0),
        Number(target.location_y ?? 0) - Number(origin.location_y ?? 0)
      )

      const discountPercent = FUEL_DISCOUNT_PERCENT_PER_SKILL_LEVEL * (skill - minNavigationSkill)
      const requiredFuel = Math.ceil((distance * FUEL_PER_DISTANCE_UNIT * (100 - discountPercent)) / 100)
      if (stardust < requiredFuel) {
        return req.error(
          400,
          `Not enough stardust for the journey to target position ${target.title}: ${requiredFuel} needed, ${stardust} available`,
          'stardustCollection'
        )
      }
    })

    return super.init()
  }
}
