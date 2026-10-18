using { galactic as db } from '../db/schema';

@path    : '/galactic'
@requires: 'authenticated-user'
service GalacticService {

  @restrict: [
    {
      grant: 'READ',
      to   : 'SpacefarerViewer',
      where: 'originPlanet_name = $user.planet'
    },
    {
      grant: [
        'READ',
        'CREATE',
        'UPDATE',
        'DELETE'
      ],
      to   : 'SpacefarerAdmin',
      where: 'originPlanet_name = $user.planet'
    }
  ]
  entity Spacefarers     as projection on db.Spacefarers;

  @readonly
  @requires: [
    'SpacefarerViewer',
    'SpacefarerAdmin'
  ]
  entity Departments     as projection on db.Departments excluding { spacefarers };

  @readonly
  @requires: [
    'SpacefarerViewer',
    'SpacefarerAdmin'
  ]
  entity Positions       as projection on db.Positions excluding { spacefarers };

  @readonly
  @requires: [
    'SpacefarerViewer',
    'SpacefarerAdmin'
  ]
  entity SpacesuitColors as projection on db.SpacesuitColors;

  @readonly
  @requires: [
    'SpacefarerViewer',
    'SpacefarerAdmin'
  ]
  entity Planets         as projection on db.Planets;
}
