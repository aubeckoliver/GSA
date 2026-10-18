import cds from '@sap/cds'

export default class GalacticService extends cds.ApplicationService {
  init() {
    const { Spacefarers } = this.entities

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

    return super.init()
  }
}
