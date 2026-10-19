using GalacticService as service from '../../srv/galactic-service';

annotate service.Spacefarers with {
    ID                      @UI.Hidden;
    firstName               @title: 'First Name';
    lastName                @title: 'Last Name';
    email                   @title: 'Email';
    stardustCollection      @title: 'Stardust Collection';
    wormholeNavigationSkill @title: 'Wormhole Navigation Skill';
    originPlanet            @title: 'Origin Planet';
    spacesuitColor          @title: 'Spacesuit Color'  @Common: {
        Text                    : spacesuitColor.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: true
    };
    department              @title: 'Department'      @Common: {
        Text           : department.name,
        TextArrangement: #TextOnly
    };
    targetLocation          @title: 'Target Location'  @Common: {
        Text           : targetLocation.name,
        TextArrangement: #TextOnly
    };
};

annotate service.Spacefarers with @(
    UI.CreateHidden       : {$edmJson: {$Path: '/GalacticService.EntityContainer/UserCapabilities/manageSpacefarersHidden'}},
    UI.UpdateHidden       : {$edmJson: {$Path: '/GalacticService.EntityContainer/UserCapabilities/manageSpacefarersHidden'}},
    UI.DeleteHidden       : {$edmJson: {$Path: '/GalacticService.EntityContainer/UserCapabilities/manageSpacefarersHidden'}},
    UI.HeaderInfo         : {
        TypeName      : 'Spacefarer',
        TypeNamePlural: 'Spacefarers',
        Title         : {Value: lastName},
        Description   : {Value: firstName}
    },
    UI.SelectionFields    : [
        lastName,
        firstName,
        stardustCollection,
        spacesuitColor_code,
        originPlanet_name,
        department_ID,
        targetLocation_ID
    ],
    UI.LineItem           : [
        {
            Value            : firstName,
            ![@UI.Importance]: #High
        },
        {
            Value            : lastName,
            ![@UI.Importance]: #High
        },
        {
            Value            : stardustCollection,
            ![@UI.Importance]: #High
        },
        {
            Value            : spacesuitColor_code,
            ![@UI.Importance]: #High
        },
        {Value: wormholeNavigationSkill},
        {Value: originPlanet_name},
        {Value: department_ID},
        {Value: targetLocation_ID},
        {Value: email}
    ],
    UI.PresentationVariant: {
        SortOrder     : [{
            Property  : lastName,
            Descending: false
        }],
        Visualizations: ['@UI.LineItem']
    },
    UI.DataPoint #Stardust: {
        Value: stardustCollection,
        Title: 'Stardust Collection'
    },
    UI.DataPoint #NavigationSkill: {
        Value        : wormholeNavigationSkill,
        Title        : 'Wormhole Navigation Skill',
        TargetValue  : 10,
        Visualization: #Rating
    },
    UI.FieldGroup #CosmicHeader: {Data: [
        {Value: spacesuitColor_code},
        {Value: originPlanet_name},
        {Value: targetLocation_ID}
    ]},
    UI.HeaderFacets       : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'StardustHeader',
            Target: '@UI.DataPoint#Stardust'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'NavigationSkillHeader',
            Target: '@UI.DataPoint#NavigationSkill'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'CosmicHeader',
            Label : 'Cosmic Profile',
            Target: '@UI.FieldGroup#CosmicHeader'
        }
    ],
    // Cosmic Object Page: sections
    UI.FieldGroup #Cosmic : {Data: [
        {Value: stardustCollection},
        {Value: spacesuitColor_code},
        {Value: wormholeNavigationSkill}
    ]},
    UI.FieldGroup #Journey: {Data: [
        {Value: originPlanet_name},
        {Value: targetLocation_ID},
        {Value: department_ID}
    ]},
    UI.FieldGroup #General: {Data: [
        {Value: firstName},
        {Value: lastName},
        {Value: email}
    ]},
    UI.Facets             : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : 'CosmicDetails',
            Label : 'Cosmic Details',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'Cosmic',
                    Label : 'Cosmic Profile',
                    Target: '@UI.FieldGroup#Cosmic'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'Journey',
                    Label : 'Cosmic Journey',
                    Target: '@UI.FieldGroup#Journey'
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'General',
            Label : 'General Information',
            Target: '@UI.FieldGroup#General'
        }
    ]
);

annotate service.Spacefarers with {
    originPlanet   @Common.ValueList: {
        CollectionPath: 'Planets',
        Parameters    : [{
            $Type            : 'Common.ValueListParameterInOut',
            LocalDataProperty: originPlanet_name,
            ValueListProperty: 'name'
        }]
    };
    department     @Common.ValueList: {
        CollectionPath: 'Departments',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: department_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'description'
            }
        ]
    };
    targetLocation @Common.ValueList: {
        CollectionPath: 'Locations',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: targetLocation_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'description'
            }
        ]
    };
};

annotate service.SpacesuitColors with {
    code @title: 'Spacesuit Color'  @Common: {
        Text           : name,
        TextArrangement: #TextOnly
    };
};

annotate service.Departments with {
    ID   @UI.Hidden  @Common.Text: name;
    name @title: 'Name';
    description @title: 'Description';
};

annotate service.Locations with {
    ID   @UI.Hidden  @Common.Text: name;
    name @title: 'Name';
    description @title: 'Description';
};

annotate service.Planets with {
    name @title: 'Planet';
};
