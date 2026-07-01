*"* use this source file for your ABAP unit test classes
class ltcl_find_flights definition final for testing
  duration medium
  risk level harmless.

  private section.

   CLASS-METHODS class_setup.
   CLASS-DATA the_carrier TYPE REF TO lcl_carrier.
   CLASS-DATA ls_result TYPE /lrn/cargoflight.
    methods:
      test_find_cargo_flight for testing raising cx_static_check.
endclass.


class ltcl_find_flights implementation.

  method test_find_cargo_flight.
*
*    SELECT SINGLE
*     FROM /LRN/CARGOFLIGHT
*     FIELDS carrier_id, connection_id, flight_date, airport_from_id, airport_to_id
*     WHERE ( maximum_load - actual_load ) >= 1
*     INTO @DATA(ls_result).
*
*    IF sy-subrc <> 0.
*     cl_abap_unit_assert=>fail(  `No suitable data in table /LRN/CARGOFLIGHT` ).
*    ENDIF.
*
*    TRY.
*     DATA(test_carrier) = NEW lcl_carrier( i_carrier_id = ls_result-carrier_id ).
*    CATCH cx_abap_invalid_value.
*     cl_abap_unit_assert=>fail(  `No suitable data in table /LRN/CARGOFLIGHT` ).
*    ENDTRY.
*
    the_carrier->find_cargo_flight(
      EXPORTING
        i_airport_from_id = ls_result-airport_from_id
        i_airport_to_id   = ls_result-airport_to_id
        i_from_date       = ls_result-flight_date
        i_cargo           = 1
      IMPORTING
        e_flight          = DATA(cargo_flight)
        e_days_later      = DATA(days_later) ).

     cl_abap_unit_assert=>assert_bound(
        act = cargo_flight
        msg = `Method find_cargo_flight does not return a result`
      ).

      cl_abap_unit_assert=>assert_equals(
        act = days_later
        exp = 0
        msg = `Method find_cargo_flight returns wrong result`
      ).

  endmethod.

  method class_setup.
    SELECT SINGLE
     FROM /lrn/cargoflight
     FIELDS carrier_id, connection_id, flight_date,
           airport_from_id, airport_to_id
     WHERE maximum_load - actual_load >= 1
     INTO @DATA(ls_result).

    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( `No suitable data in table /LRN/CARGOFLIGHT` ).
    ENDIF.

    TRY.
      DATA(the_carrier) = NEW lcl_carrier( i_carrier_id =
                                             ls_result-carrier_id ).
    CATCH cx_abap_invalid_value.
      cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).
    ENDTRY.

  endmethod.

endclass.
