*&---------------------------------------------------------------------*
*& Report ZDLRP_HTML
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDLRP_HTML.

SELECTION-SCREEN PUSHBUTTON 3(3) TEXT-001 USER-COMMAND btn.

CLASS lcl_html_dashboard DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_event,
            eventid    TYPE i,
            appl_event TYPE xfeld,
           END OF ty_event.
    TYPES: tt_event TYPE TABLE OF ty_event WITH DEFAULT KEY.

    DATA: lv_doc_url TYPE c LENGTH 80.

    METHODS generate_container.
    METHODS get_html RETURNING VALUE(rt_html) TYPE w3_htmltab.
    METHODS on_sapevent FOR EVENT sapevent OF cl_gui_html_viewer
                        IMPORTING action
                                  frame
                                  getdata
                                  postdata
                                  query_table.

ENDCLASS.

CLASS lcl_html_dashboard IMPLEMENTATION.

  METHOD generate_container.

    DATA(lo_dock) = NEW cl_gui_docking_container( repid                   = sy-cprog
                                                  dynnr                   = sy-dynnr
                                                  side                    = cl_gui_docking_container=>dock_at_bottom
                                                  extension               = 1800
                                                  no_autodef_progid_dynnr = 'X'
                                                ).

    DATA(lo_html) = NEW cl_gui_html_viewer( parent = lo_dock ).
    CALL METHOD cl_gui_cfw=>flush.

    DATA(lt_events) = VALUE tt_event( ( eventid = lo_html->m_id_sapevent
                                        appl_event = 'X' ) ).
    lo_html->set_registered_events( events = lt_events ).
    SET HANDLER on_sapevent FOR lo_html.

    DATA(lt_html) = get_html( ).
    lo_html->load_data( IMPORTING assigned_url = lv_doc_url
                        CHANGING  data_table   = lt_html ).

    lo_html->load_data(
      EXPORTING type          = 'text'
                subtype       = 'html'
      IMPORTING assigned_url  = lv_doc_url
      CHANGING  data_table    = lt_html
      EXCEPTIONS others       = 1
    ).

    lo_html->show_data( url = lv_doc_url ).

  ENDMETHOD.

  METHOD get_html.

    READ REPORT 'ZDLI_DASHBOARD_FIORI_HTML' INTO rt_html.

  ENDMETHOD.

  METHOD on_sapevent.

    MESSAGE |Você clicou em { action }| TYPE 'S'.

    IF action(2) = 'CT'.
      CALL TRANSACTION action+3.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

INITIALIZATION.
  DATA(lo) = NEW lcl_html_dashboard( ).
  lo->generate_container( ).