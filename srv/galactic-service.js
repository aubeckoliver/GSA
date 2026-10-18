import cds from '@sap/cds'

const STARDUST_WELCOME_BONUS = 100
const STARDUST_PER_SKILL_BOOST = 1000

export default class GalacticService extends cds.ApplicationService {
  init() {
    const { Spacefarers } = this.entities
    const { stardustCollection: stardustElement, wormholeNavigationSkill: navSkillElement } = Spacefarers.elements
    const [minStardust] = stardustElement['@assert.range']
    const defaultStardust = stardustElement.default?.val ?? minStardust
    const [minNavigationSkill, maxNavigationSkill] = navSkillElement['@assert.range']
    const defaultNavigationSkill = navSkillElement.default?.val ?? minNavigationSkill

    this.before(['CREATE', 'UPDATE'], Spacefarers, req => {
      const planet = req.user.attr?.planet
      if (!planet) return req.reject(403, 'No planet assigned to your user')

      const target = req.data.originPlanet
      if (req.event === 'CREATE' || target !== undefined) {
        if (target !== planet) {
          return req.reject(403, `You may only manage spacefarers from planet ${planet}`)
        }
      }
    })

    this.before('CREATE', Spacefarers, req => {
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

      data.stardustCollection = stardust + STARDUST_WELCOME_BONUS
      const skillBoost = Math.floor(stardust / STARDUST_PER_SKILL_BOOST)
      data.wormholeNavigationSkill = Math.min(skill + skillBoost, maxNavigationSkill)
    })

    return super.init()
  }
}
