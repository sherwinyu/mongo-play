Sysys.ActView = Ember.View.extend
  templateName: 'act'
  classNameBindings: ['context.isDirty:dirty']

  submit: (e)->
    @get('controller')?.commitAct() # Sysys.store.commit()
    false

  init: ->
    @_super()
