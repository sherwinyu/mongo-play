describe "HumonNodeView", ->
  beforeEach ->
    @serialized = #a: { a: 1, b: 2 }, flat: 5
      {
        hash2:
          hash1:
            hash0: 0
            hash0b: "b"
        array2:
          [
            [
              314
              415
            ]
            417
          ]
        scalar:
          "scalar" 
        list: [
          "zup"
          a: 5
        ]
          
      }
    ###
      ###


        #{a: 0, b: {b0: 5, b1: 7}, c: 1 }
        # @details = Sysys.JSONWrapper.recursiveDeserialize(@serialized)

    # json = {a: '5', b: 6 }
    # json = true
    json = [1, "lala", {a: 'b'}]
    json = @serialized
    @humonNode = Sysys.HumonUtils.json2humonNode json 
    window.controller = Sysys.DetailController.create()
    @humonNodeView = Sysys.HumonNodeView.create content: @humonNode, controller: window.controller
    window.controller.set('activeHumonNodeView', @humonNodeView)
    window.controller.set('activeHumonNode', @humonNodeView.get('content'))
    window.wala = @humonNodeView

    Ember.run =>
      @humonNodeView.append()

  afterEach ->
    Ember.run =>
      # @humonNodeView.remove()
      # @humonNodeView.destroy()

  it "should display nested node views", ->
    console.log 'chogal'
