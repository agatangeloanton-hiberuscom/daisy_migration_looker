# Phase 5 content — port of the OBIEE analysis `Población por Sexo`.
# Source: OBIEE/visualizacion_obiee/Análisis/Análisis - Población por Sexo.xml
#
# WHY THIS IS A DASHBOARD AND NOT A "LOOK".
# The migration plan (§5 Phase 5) calls for "the 3 analyses as Looks". LookML has no
# Look primitive: a Look is a user-created object stored in the Looker instance's
# internal database, not a file a project can contain. The nearest thing a LookML
# project can hold — and the only one that is version-controlled, reviewable and
# deployable the way this migration requires — is a single-element LookML dashboard,
# which is independently viewable and linkable exactly as a Look is. So this file is
# ONE analysis, not a change of scope. It is also embedded, unchanged, as an element of
# censo_aragon.dashboard.lookml, which is what `Panel de Control - Censo Aragón` does
# with it (reportView "Report 1").
#
# The 8 filters are ported from this analysis's own `<saw:filter>` block, where all 8
# are `op="prompted"` (R9.1). They are repeated on all four dashboards because each of
# the 3 analyses declares its own 8 — and because without the `Año Censo` filter the
# element would sum all five census years, 2021–2025, which the OBIEE dashboard never
# shows. See censo_aragon.dashboard.lookml for the full BLK-002 discussion; the same
# inference marks apply here.
- dashboard: poblacion_por_sexo
  title: "Población por Sexo"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Sexo` (subject area TEST_LOOKER). Rendered as a single-element dashboard because LookML has no Look primitive."

  filters:
  # ── R9.1 — the 8 prompted fields, all `op="prompted"` in the source XML. ──
  # BLK-002 applies to every one of them: `Petición de datos - Filtro_Poblacion.xml` is
  # a byte-identical duplicate of `Análisis - Población por Sexo.xml`, so the prompt
  # definition is not in this estate and NO default or value list below is ported —
  # each is either inferred (and marked) or deliberately left unset.
  - name: sexo
    title: "Sexo"
    # BLK-002 (inferred): control type. `field_filter` and Looker's default multi-select
    # are chosen; the OBIEE prompt's control, operator and value list are unrecoverable.
    # No default — R9.4 forbids inventing one.
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
    # BLK-003: the dashboard's hidden prompt V_SET_ANYO (Panel de Control - Layout.xml:4)
    # is argued inert in 01-migration-plan.md §5.1 — different subject area, no
    # presentation variables in the estate — so 2025 is a CHOSEN default, not a ported
    # one. If BLK-003 turns out to be wrong, this is the line that is wrong with it.
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
  - name: poblacion_por_sexo
    # `<saw:dvtchart> <saw:display type="pie" subtype="default">` → looker_pie.
    # Title is the analysis's own `titleView!1` caption, verbatim (lowercase `sexo`).
    title: "Población por sexo"
    model: censo_anual
    explore: censo_anual
    type: looker_pie
    # `<saw:measures><saw:column measureType="pie">` → columnID c87da0157ddc02bab =
    #   "Medidas"."Personas"                              → fct_censo_anual.personas
    # `<saw:seriesGenerators>`                → columnID c51dd82505b462219 =
    #   "Edad y Sexo"."Sexo"                              → dim_sexo.sexo
    # `<saw:categories>` holds only `<saw:measureLabels/>`, i.e. no category column —
    # which is what makes this a one-dimension pie rather than a series of pies.
    fields: [dim_sexo.sexo, fct_censo_anual.personas]
    # INFERRED. The XML declares no sort. Ascending `Sexo` gives Hombre, Mujer — the
    # order the chart's own `<saw:seriesCondition position="1">` / `position="2"` colour
    # rules assume, so this reproduces the OBIEE rendering rather than inventing one.
    sorts: [dim_sexo.sexo]
    # `<saw:visualFormat color="#2986cc"/>` at series position 1, `#c90076` at
    # position 2. Ported by value rather than by position — DIM_SEXO_DATA_TABLE.csv is
    # exactly 3 rows (1 Hombre, 6 Mujer, 0 Desconocido/a) and the sort above puts
    # Hombre first, so position 1 = Hombre. Desconocido/a carries no OBIEE colour.
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    # `<saw:legendFormat position="none">` + `<saw:dataLabels display="always"
    # position="outsidewithleader">` → labels on the slices, no legend.
    # `label_type` is deliberately NOT set: OBIEE's `valueAs="default"` does not
    # unambiguously mean value or percentage, so Looker's default stands rather than a
    # guess. Flagged in the migration report.
    value_labels: labels
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    # `<saw:canvasFormat height="350" width="500">`. Newspaper rows are 50px, so
    # height 7 = 350px. Width is the full 24-column grid: the OBIEE 500px is the width
    # it had sharing a row with the municipio table on the panel, not standalone.
    row: 0
    col: 0
    width: 24
    height: 7
