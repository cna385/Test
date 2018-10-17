*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_handler DEFINITION INHERITING FROM cl_abap_behavior_handler FINAL.

  PUBLIC SECTION.

  PRIVATE SECTION.
    " name of a BEHAVIOR method must be "MODIFY | READ | LOCK
    METHODS modify FOR BEHAVIOR IMPORTING
                                  do_somethings FOR ACTION zpersonname~do_something
                                                       RESULT did_somethings.

ENDCLASS.

CLASS lcl_buffer DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ts_do_something,
             id TYPE sysuuid_x16,
           END OF ts_do_something,
           tt_do_somethings TYPE STANDARD TABLE OF ts_do_something WITH DEFAULT KEY.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_buffer.
    METHODS: set_do_somethings IMPORTING it_do_somethings TYPE tt_do_somethings,
      get_do_somethings RETURNING VALUE(rt_do_somethings) TYPE tt_do_somethings.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: go_instance TYPE REF TO lcl_buffer.
    DATA: mt_do_somethings TYPE tt_do_somethings.

ENDCLASS.

CLASS lcl_saver DEFINITION INHERITING FROM cl_abap_behavior_saver FINAL.
  PROTECTED SECTION.
    METHODS save              REDEFINITION.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD modify.

    IF do_somethings IS NOT INITIAL.

      DATA lt_do_somethings TYPE lcl_buffer=>tt_do_somethings.
      DATA ls_do_something LIKE LINE OF lt_do_somethings.
      LOOP AT do_somethings REFERENCE INTO DATA(lr_do_something).
        CLEAR ls_do_something.
        ls_do_something-id = lr_do_something->id.
        INSERT ls_do_something INTO TABLE lt_do_somethings.
      ENDLOOP.
      lcl_buffer=>get_instance( )->set_do_somethings( lt_do_somethings ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_buffer IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.

  METHOD set_do_somethings.
    mt_do_somethings = it_do_somethings.
  ENDMETHOD.

  METHOD get_do_somethings.
    rt_do_somethings = mt_do_somethings.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_saver IMPLEMENTATION.

  METHOD save.
    " register business partner in local system
    DATA(lt_do_somethings) = lcl_buffer=>get_instance( )->get_do_somethings( ).
    DATA ls_do_something TYPE ztperson.

    LOOP AT lt_do_somethings INTO DATA(ls_do_a_thing).
      ls_do_something-id = ls_do_a_thing-id.
      ls_do_something-something = 'Did Something'.
      MODIFY ztperson FROM @ls_do_something.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
