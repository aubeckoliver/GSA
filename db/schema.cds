namespace galactic;

using {
  cuid,
  managed,
  sap.common.CodeList
} from '@sap/cds/common';

type Coordinates {
  x : Decimal(15, 3) default 0;
  y : Decimal(15, 3) default 0;
}

entity Spacefarers : cuid, managed {
  firstName               : String(50) @mandatory;
  lastName                : String(50) @mandatory;
  email                   : String(100) @mandatory @assert.format: '^[^\s@]+@[^\s@]+\.[^\s@]+$';
  stardustCollection      : Integer default 0 @mandatory @assert.range: [0, _];
  wormholeNavigationSkill : Integer default 1 @mandatory @assert.range: [1, 10];
  originPlanet            : Association to Planets @mandatory @assert.target;
  spacesuitColor          : Association to SpacesuitColors;
  department              : Association to Departments;
  targetLocation          : Association to Locations @mandatory @assert.target;
}

entity Departments : cuid, managed {
  name        : String(100) @mandatory;
  description : String(1000);
  spacefarers : Association to many Spacefarers on spacefarers.department = $self;
}

entity Locations : cuid, managed {
  name        : String(100) @mandatory;
  description : String(1000);
  location    : Coordinates;
  spacefarers : Association to many Spacefarers on spacefarers.targetLocation = $self;
}

entity Planets : managed {
  key name     : String(100);
      location : Coordinates;
}

entity SpacesuitColors : CodeList {
  key code : String(20);
}
