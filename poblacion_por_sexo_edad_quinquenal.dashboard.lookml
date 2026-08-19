# Phase 5 content — port of the OBIEE analysis `Población por Sexo y Edad (quinquenal)`.
# Source: OBIEE/visualizacion_obiee/Análisis/Análisis - Población por Sexo y Edad (quinquenal).xml
#         (R8.2c — parenthesised, lowercase `quinquenal`; the path was stat'd, not assumed)
#
# WHY THIS IS A DASHBOARD AND NOT A "LOOK".
# The migration plan (§5 Phase 5) calls for "the 3 analyses as Looks". LookML has no
# Look primitive: a Look is a user-created object stored in the Looker instance's
# internal database, not a file a project can contain. The nearest thing a LookML
# project can hold — and the only one that is version-controlled, reviewable and
# deployable the way this migration requires — is a single-element LookML dashboard,
# which is independently viewable and linkable exactly as a Look is. So this file is
# ONE analysis, not a change of scope. It is also embedded, unchanged, as an element of
# censo_aragon.dashboard.lookml (reportView "Report 2").
#
# The 8 filters are ported from this analysis's own `<saw:filter>` block, where all 8
# are `op="prompted"` (R9.1). BLK-002 marks below; full discussion in
# censo_aragon.dashboard.lookml.
- dashboard: poblacion_por_sexo_edad_quinquenal
  title: "Población por Sexo y Edad (quinquenal)"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Sexo y Edad (quinquenal)` (subject area TEST_LOOKER). Rendered as a single-element dashboard because LookML has no Look primitive."

  filters:
  # ── R9.1 — the 8 prompted fields, all `op="prompted"` in the source XML. ──
  # BLK-002: `Petición de datos - Filtro_Poblacion.xml` is a byte-identical duplicate of
  # another analysis, so no default or value list below is ported.
  - name: sexo
    title: "Sexo"
    # BLK-002 (inferred): control type only. No default — R9.4 forbids inventing one.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_sexo.sexo
  - name: edad_grupos_quinquenales
    title: "Edad (grupos quinquenales)"
    # BLK-002 (inferred): control type only. No default.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_edad.edad_grupos_quinquenales
  - name: anno_censo
    title: "Año Censo"
    # R9.2 — the ONE default in this file. 2025 = DEFAULT_ANNO_CENSO in .env.
    # BLK-002 (inferred): the real prompt default is unrecoverable.
    # BLK-003: V_SET_ANYO is a hidden prompt from another subject area, argued inert in
    # 01-migration-plan.md §5.1, so 2025 is a CHOSEN default, not a ported one.
    type: field_filter
    default_value: '2025'
    model: censo_anual
    explore: censo_anual
    field: fct_censo_anual.anno_censo
  - name: nacionalidad_pais_nombre
    title: "Nacionalidad país nombre"
    # BLK-002 (inferred): control type only. No default.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_pais.nacionalidad_pais_nombre
  - name: residencia_provincia_nombre
    title: "Residencia provincia nombre"
    # BLK-002 (inferred): control type only. No default.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_provincia_nombre
  - name: residencia_comarca_nombre
    title: "Residencia comarca nombre"
    # BLK-002 (inferred): control type only. No default.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_comarca_nombre
  - name: residencia_municipio_nombre
    title: "Residencia municipio nombre"
    # BLK-002 (inferred): control type only. No default.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_nombre
  - name: residencia_municipio_codigo
    title: "Residencia municipio código"
    # BLK-002 (inferred): control type only. No default.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_codigo

  elements:
  - name: poblacion_por_sexo_edad_quinquenal
    # `<saw:dvtchart> <saw:display type="bar" subtype="stacked">`.
    #
    # DELIBERATE DEPARTURE FROM THE BRIEF: `looker_column`, not `looker_bar`.
    # In Looker `looker_bar` draws HORIZONTAL bars and `looker_column` draws vertical
    # ones. The source is vertical: `<saw:axesFormats>` puts the rotatable, 9pt,
    # skip-enabled category labels on `axis="X"` and leaves `axis="Y1"` bare, and the
    # canvas is 1250 wide × 200 tall — 21 quinquenal groups laid out left to right.
    # `looker_bar` would rotate the age axis 90° and change what the user sees.
    # Flagged in the Phase 5 report; revert to `looker_bar` if the client disagrees.
    title: "Población por Sexo y Edad (quinquenal)"
    model: censo_anual
    explore: censo_anual
    type: looker_column
    # `<saw:selections>` columnIDs resolved against `<saw:columns>`:
    #   category      c9c9b4a20291bad9c = "Edad y Sexo"."Edad (grupos quinquenales)"
    #                                                   → dim_edad.edad_grupos_quinquenales
    #   measure (y)   c87da0157ddc02bab = "Medidas"."Personas"  → fct_censo_anual.personas
    #   seriesGenerator c51dd82505b462219 = "Edad y Sexo"."Sexo" → dim_sexo.sexo
    # Note c51dd82505b462219 is the SAME columnID as the series generator in
    # `Población por Sexo`; the two analyses share column IDs, which is why the refs
    # were resolved back to `<saw:column>` rather than assumed from position.
    fields: [dim_edad.edad_grupos_quinquenales, dim_sexo.sexo, fct_censo_anual.personas]
    # A series generator is a Looker pivot: one column series per Sexo value.
    pivots: [dim_sexo.sexo]
    # INFERRED. The XML declares no sort. GRUPOS_QUINQUENALES is zero-padded in
    # DIM_EDAD_DATA_TABLE.csv ("00 a 04" … "95 y más"), so ascending string order is
    # the natural age order, with "Desconocido/a" (the edad = -1 sentinel, R5.3) last.
    sorts: [dim_edad.edad_grupos_quinquenales]
    # `subtype="stacked"` → stacking: normal (absolute values, not percentages;
    # `percentStacked` is a separate OBIEE subtype and is not what this XML says).
    stacking: normal
    # `<saw:visualFormat color="#2986cc"/>` at series position 1, `#c90076` at
    # position 2. Keyed by value: the pivot sorts Hombre before Mujer.
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    # `<saw:legendFormat position="default">` — legend shown, unlike the pie.
    show_legend: true
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    # `<saw:canvasFormat height="200" width="1250">`. Newspaper rows are 50px, so
    # height 4 = 200px; width 24 is the full grid, matching the near-full-width 1250px
    # this chart occupies alone on the OBIEE panel (Section 0).
    row: 0
    col: 0
    width: 24
    height: 4
