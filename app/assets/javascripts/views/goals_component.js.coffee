#= require ./humon_editor_component

Sysys.GoalsEditorComponent = Sysys.HumonEditorComponent.extend
  classNames: ['humon-editor', 'goals-component']
  justAVar: "wargstabul"
  input_json: null

  init: ->
    @set("input_json", [{goal: "what'sup", completed_at: null}])
    @_super()
