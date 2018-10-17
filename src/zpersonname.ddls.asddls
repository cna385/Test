@QueryImplementedBy: 'ZCL_PERSON_QUERY_PROVIDER'

@EndUserText.label: 'Persons'
 
 @OData.entitySet.name: 'PersonName' 
 @OData.entityType.name: 'PersonName' 
 
 @UI: {
  headerInfo: {
    typeName: 'Person',
    typeNamePlural: 'Persons',
    title: { type: #STANDARD, value: 'FirstName' }
  }, 
  presentationVariant: [ { sortOrder: [ { by: 'Id', direction: #DESC } ] } ]
}

@Search.searchable: true
 define root custom entity ZPERSONNAME { 

  @UI.facet: [
        {
          id:       'Person',
          purpose:  #STANDARD,
          type:     #IDENTIFICATION_REFERENCE,
          label:    'Person',
          position: 10 }
      ]
      
  @UI: { 
      lineItem: [ {
                    type: #FOR_ACTION,
                    dataAction: 'DO_SOMETHING',
                    label: 'Do Something',
                    invocationGrouping: #ISOLATED
                   }
                 ]
      }
  key Id : sysuuid_x16 ; 
  
  @UI: {
      lineItem: [ { position: 20, label: 'First Name' } ],
      identification: [{ position: 20, label: 'First Name' }]
      }
  @Search.defaultSearchElement: true
  FirstName : abap.char( 40 ) ; 
  
  @UI: {
      lineItem: [ { position: 30, label: 'Last Name' } ],
      identification: [{ position: 30, label: 'Last Name' }]
      }      
  LastName : abap.char( 40 ) ; 
  
  @UI: {
      lineItem: [ { position: 40, label: '' } ],
      identification: [{ position: 40, label: '' }]
      }      
  Something : abap.char( 40 ) ; 
 } 
