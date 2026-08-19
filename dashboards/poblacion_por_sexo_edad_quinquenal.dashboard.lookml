- dashboard: poblacion_por_sexo_edad_quinquenal
  title: "Población por Sexo y Edad (quinquenal)"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Sexo y Edad (quinquenal)` (subject area TEST_LOOKER)."
  filters:
  - name: sexo
    title: "Sexo"
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_sexo.sexo
  - name: edad_grupos_quinquenales
    title: "Edad (grupos quinquenales)"
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_edad.edad_grupos_quinquenales
  - name: anno_censo
    title: "Año Censo"
    type: field_filter
    default_value: '2025'
    model: censo_anual
    explore: censo_anual
    field: fct_censo_anual.anno_censo
  - name: nacionalidad_pais_nombre
    title: "Nacionalidad país nombre"
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_pais.nacionalidad_pais_nombre
  - name: residencia_provincia_nombre
    title: "Residencia provincia nombre"
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_provincia_nombre
  - name: residencia_comarca_nombre
    title: "Residencia comarca nombre"
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_comarca_nombre
  - name: residencia_municipio_nombre
    title: "Residencia municipio nombre"
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_nombre
  - name: residencia_municipio_codigo
    title: "Residencia municipio código"
    type: field_filter
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_codigo
  elements:
  - name: poblacion_por_sexo_edad_quinquenal
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
