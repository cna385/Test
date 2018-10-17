CLASS zcl_person_query_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_a4c_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_person_query_provider IMPLEMENTATION.

  METHOD if_a4c_rap_query_provider~select.
    DATA lt_persons TYPE TABLE OF zpersonname.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
                                 i_name                  = 'space-travel-business-partners'
                                 i_service_instance_name = 'space-travel-destination'
                                 i_authn_mode            = if_a4c_cp_service=>service_specific ).

        DATA(lo_web_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        lo_web_client->get_http_request( )->set_header_field( i_name = 'x-csrf-token' i_value = 'POK$Pq202ieq092ei12' ).

        DATA(lo_odata_client) = cl_web_odata_client_factory=>create_v2_remote_proxy(
                                  iv_service_definition_name = 'ZSD_PERSON'
                                  io_http_client             = lo_web_client
                                  iv_relative_service_root   = '/odata/v2/API_BUSINESS_PARTNER' ).

        DATA(lo_odata_resource) = lo_odata_client->create_resource_for_entity_set( 'PERSONNAME' ).

        DATA(lo_odata_response) = lo_odata_resource->create_request_for_read( )->execute( ).
        lo_odata_response->get_business_data( IMPORTING et_business_data = lt_persons ).

        LOOP AT lt_persons ASSIGNING FIELD-SYMBOL(<fs_person>).
          SELECT SINGLE something FROM ztperson WHERE id = @<fs_person>-id INTO @<fs_person>-something.
        ENDLOOP.

        io_response->set_data( it_data = lt_persons ).
      CATCH cx_root.
        "Should not happen! :)
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
