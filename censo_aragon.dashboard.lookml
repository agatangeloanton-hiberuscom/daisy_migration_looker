# Phase 5 content — port of the OBIEE dashboard `Panel de Control - Censo Aragón`.
# Sources (both paths stat'd, not assumed — R8.2c: the directory is lowercase
# `Panel de control/` while the filenames carry a capital `Control`):
#   OBIEE/visualizacion_obiee/Panel de control/Panel de Control - Censo Aragón.xml
#   OBIEE/visualizacion_obiee/Panel de control/Panel de Control - Layout.xml
#
# It hosts the same three analyses that ship as standalone dashboards beside this file
# (poblacion_por_sexo, poblacion_por_sexo_edad_quinquenal, poblacion_por_municipio) —
# `<sawd:reportView>` Report 2, Report 0 and Report 1 respectively — plus the visible
# `Filtro_Poblacion` prompt panel, which becomes the 8 dashboard filters below.
#
# ── BLK-002: THE ONE THING THIS WAVE CANNOT REPORT AS DONE ──────────────────────
# `Petición de datos - Filtro_Poblacion.xml` in this export is a BYTE-IDENTICAL
# duplicate of `Análisis - Población por Sexo.xml`. The real prompt definition is not in
# the estate, so the prompts' DEFAULTS and VALUE LISTS are not recoverable from
# anything here. What IS recoverable, and is therefore ported rather than inferred, is
# the set of 8 prompted fields — every one of the 3 analyses declares the same 8
# `op="prompted"` filters, which is R9.1.
#
# Every filter below therefore carries a `BLK-002 (inferred)` line naming exactly what
# was chosen rather than read. No allowed-values list is fabricated anywhere in this
# file, and the only `default_value` in it is `Año Censo`, per R9.2.
#
# ── BLK-003: V_SET_ANYO is NOT implemented ─────────────────────────────────────
# `Panel de Control - Layout.xml:4` declares
#   <sawd:dashboardHiddenPromptRef>/shared/SET/ASENTAMIENTOS/Análisis/V_SET_ANYO</…>
# A *hidden* dashboard prompt from a *different* subject area. 01-migration-plan.md
# §5.1 argues it inert on four pieces of evidence (all 3 analyses declare
# subjectArea="TEST_LOOKER" only; zero presentation variables anywhere in the estate;
# all 32 filters are `op="prompted"`; ASENTAMIENTOS appears nowhere else). It is not
# ported. Its consequence is recorded on the `anno_censo` filter: 2025 is a *chosen*
# default, not one read from OBIEE.
- dashboard: censo_aragon
  # `<sawd:htmlView name="HTML 1">` carries `<h1>📊 Censo anual de población de
  # Aragón</h1>`, and `Panel de Control - Layout.xml` names the page
  # `Censo anual de población`. The heading text is used as the dashboard title, which
  # is the closest LookML has — see the "not expressible" note at the foot of this file.
  title: "Censo anual de población de Aragón"
  layout: newspaper
  description: "Port of the OBIEE dashboard `Panel de Control - Censo Aragón`: the three TEST_LOOKER analyses plus the 8 prompted fields of Filtro_Poblacion (R9.1). Prompt defaults and value lists are not recoverable — BLK-002."

  filters:
  # ── R9.1 — the 8 prompted fields, in the order the `<saw:filter>` blocks declare ──
  # them. Identical across all three analyses; verified in each XML, not assumed from
  # one. Read the BLK-002 header above before adding a default to any of these.
  - name: sexo
    title: "Sexo"
    # OBIEE: "Edad y Sexo"."Sexo", op="prompted".
    # BLK-002 (inferred): the control type. `field_filter` with Looker's default
    # multi-select is chosen; the OBIEE prompt's control (dropdown / checkboxes /
    # list), its operator, and whether it constrained to a value list are all
    # unrecoverable. NO default value — R9.4 forbids inventing one.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_sexo.sexo
  - name: edad_grupos_quinquenales
    title: "Edad (grupos quinquenales)"
    # OBIEE: "Edad y Sexo"."Edad (grupos quinquenales)", op="prompted".
    # BLK-002 (inferred): control type only. No default, no value list.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_edad.edad_grupos_quinquenales
  - name: anno_censo
    title: "Año Censo"
    # OBIEE: "Fecha Referencia Censo"."Año Censo", op="prompted".
    #
    # THE ONLY DEFAULT IN THIS FILE, and it is inferred twice over:
    #   R9.2 — 2025 is DEFAULT_ANNO_CENSO from .env, the latest year in the fixtures.
    #   BLK-002 — the real prompt default is unrecoverable, so this is a choice.
    #   BLK-003 — V_SET_ANYO is argued inert (see header), which is what makes this
    #             visible filter the year selector at all. If that argument is wrong,
    #             OBIEE's panel was pinned to some other year and every number on this
    #             dashboard differs by year. This line is where that risk lands.
    # BLK-002 (inferred): control type, as for every other filter.
    type: field_filter
    default_value: '2025'
    model: censo_anual
    explore: censo_anual
    field: fct_censo_anual.anno_censo
  - name: nacionalidad_pais_nombre
    title: "Nacionalidad país nombre"
    # OBIEE: "Nacionalidad"."Nacionalidad país nombre", op="prompted".
    # BLK-002 (inferred): control type only. No default, no value list.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_pais.nacionalidad_pais_nombre
  - name: residencia_provincia_nombre
    title: "Residencia provincia nombre"
    # OBIEE: "Lugar de Residencia"."Residencia provincia nombre", op="prompted".
    # BLK-002 (inferred): control type only. No default, no value list. In particular
    # nothing here scopes the dashboard to Aragón, because nothing in the XML does.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_provincia_nombre
  - name: residencia_comarca_nombre
    title: "Residencia comarca nombre"
    # OBIEE: "Lugar de Residencia"."Residencia comarca nombre", op="prompted".
    # BLK-002 (inferred): control type only. No default, no value list. Note R5.1 —
    # 'Sin definir' is a real member on 91% of the dimension and will appear in the
    # value list Looker builds from the data.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_comarca_nombre
  - name: residencia_municipio_nombre
    title: "Residencia municipio nombre"
    # OBIEE: "Lugar de Residencia"."Residencia municipio nombre", op="prompted".
    # BLK-002 (inferred): control type only. No default, no value list.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_nombre
  - name: residencia_municipio_codigo
    title: "Residencia municipio código"
    # OBIEE: "Lugar de Residencia"."Residencia municipio código", op="prompted".
    # BLK-002 (inferred): control type only. No default, no value list.
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_codigo

  elements:
  # Layout follows `Panel de Control - Censo Aragón.xml`'s own column/section order in
  # `<sawd:dashboardColumn name="Column 0">`:
  #   Section 0  reportView "Report 2"  Población por Sexo y Edad (quinquenal)   full width
  #   Section 2  horizontalLayout="true"
  #              reportView "Report 0"  Población por Municipio                  left
  #              reportView "Report 1"  Población por Sexo                       right
  # Widths keep the sources' own proportion: the table's canvas is 1500px and the pie's
  # is 500px, i.e. 3:1, which is 18 and 6 of the 24-column newspaper grid.

  - name: poblacion_por_sexo_edad_quinquenal
    # `<sawd:reportView name="Report 2">`, caption verbatim.
    # Identical to the element in poblacion_por_sexo_edad_quinquenal.dashboard.lookml —
    # including the deliberate `looker_column` (not `looker_bar`) choice documented
    # there: OBIEE's `type="bar"` puts the categories on `axis="X"`, i.e. vertical.
    title: "Población por Sexo y Edad (quinquenal)"
    model: censo_anual
    explore: censo_anual
    type: looker_column
    fields: [dim_edad.edad_grupos_quinquenales, dim_sexo.sexo, fct_censo_anual.personas]
    pivots: [dim_sexo.sexo]
    sorts: [dim_edad.edad_grupos_quinquenales]
    stacking: normal
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    show_legend: true
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 0
    col: 0
    width: 24
    height: 4

  - name: poblacion_por_municipio
    # `<sawd:reportView name="Report 0">`, caption verbatim. Left half of Section 2.
    # Identical to the element in poblacion_por_municipio.dashboard.lookml; the R9.3
    # helper-reuse argument, the BLK-006 Maleján note and the `limit: 5000` rationale
    # are documented there rather than repeated.
    title: "Población por Municipio"
    model: censo_anual
    explore: censo_anual
    type: looker_grid
    fields: [dim_territorio.residencia_municipio_codigo, dim_territorio.residencia_municipio_nombre,
      fct_censo_anual.poblacion_hombres, fct_censo_anual.poblacion_mujeres,
      fct_censo_anual.personas, fct_censo_anual.densidad_municipio]
    series_labels:
      dim_territorio.residencia_municipio_codigo: "Cod. Municipio"
      dim_territorio.residencia_municipio_nombre: "Municipio"
      fct_censo_anual.poblacion_hombres: "Población (Hombres)"
      fct_censo_anual.poblacion_mujeres: "Población (Mujeres)"
      fct_censo_anual.personas: "Población"
      fct_censo_anual.densidad_municipio: "Densidad de población"
    show_totals: true
    show_view_names: false
    sorts: [dim_territorio.residencia_municipio_codigo]
    limit: 5000
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 4
    col: 0
    width: 18
    height: 7

  - name: poblacion_por_sexo
    # `<sawd:reportView name="Report 1">`, caption verbatim. Right of Section 2.
    # NOTE the two titles that differ by one character, both ported as written: the
    # dashboard's reportView caption is `Población por Sexo` and the analysis's own
    # `titleView!1` caption is `Población por sexo`. On the panel, OBIEE shows the
    # reportView caption, so that is what this element carries.
    # Identical otherwise to the element in poblacion_por_sexo.dashboard.lookml.
    title: "Población por Sexo"
    model: censo_anual
    explore: censo_anual
    type: looker_pie
    fields: [dim_sexo.sexo, fct_censo_anual.personas]
    sorts: [dim_sexo.sexo]
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    value_labels: labels
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 4
    col: 18
    width: 6
    height: 7

# ── What this file could NOT express, listed here so it is not mistaken for done ──
#  * The left filter COLUMN. OBIEE freezes a 410px `<sawd:dashboardColumn name="Column
#    1">` with a #EEEEEE background holding the prompt panel beside the content.
#    Looker renders dashboard filters in its own top filter bar; a LookML dashboard has
#    no per-column layout and no way to place filters beside tiles.
#  * The two `<sawd:htmlView>` tiles. `<h1>📊 Censo anual de población de Aragón</h1>`
#    is folded into `title:` above; `<h2>🔎 Filtros</h2>` is dropped, since Looker
#    labels its own filter bar. Both could be re-added as `type: text` elements if the
#    client wants the emoji headings back — they were left out rather than invented,
#    since neither carries data.
#  * `<sawd:dashboardSection name="Section 1">`, an empty 375px spacer under the prompt
#    panel. Nothing to port.
#  * Per-tile styling generally: OBIEE's `hAlign`/`vAlign`/`paddingLeft="50"`/border
#    settings, the grid's `greenBarFormat` alternating #EEEEEE row shading, and the
#    table's black (#000000) dimension headers vs grey (#666666) measure headers have
#    no LookML dashboard equivalent.
#  * The `<saw:tableHeading>` band above the grid's column headings
#    (Lugar de Residencia | Medidas | Indicadores). `show_view_names` is the nearest
#    thing and it shows the LookML view labels, not these captions, so it is off.
