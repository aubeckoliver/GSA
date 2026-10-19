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
    UI.FieldGroup #General: {Data: [
        {Value: firstName},
        {Value: lastName},
        {Value: email},
        {Value: originPlanet_name},
        {Value: department_ID}
    ]},
    UI.FieldGroup #Journey: {Data: [
        {Value: stardustCollection},
        {Value: wormholeNavigationSkill},
        {Value: spacesuitColor_code},
        {Value: targetLocation_ID}
    ]},
    UI.Facets             : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'General',
            Label : 'General Information',
            Target: '@UI.FieldGroup#General'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Journey',
            Label : 'Cosmic Journey',
            Target: '@UI.FieldGroup#Journey'
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
