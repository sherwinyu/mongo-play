describe "HumonNode UI integration", ->
  beforeEach ->
    @serialized =
      {
        hash2:
          hash1:
            hash0: 0
            hash0b: "b"
        array2:
          [
            [
              314
            ]
          ]
        scalar:
          "scalar"
      }
    json = @serialized
    @humonNode = Sysys.HumonUtils.json2humonNode json 
    @humonNodeView = Sysys.HumonNodeView.create content: @humonNode, controller: Sysys.DetailController.create(), displayStats: true

    Ember.run =>
      @humonNodeView.append()

  afterEach ->
    Ember.run =>
      # @humonNodeView.remove()
      # @humonNodeView.destroy()
  it "should run", ->