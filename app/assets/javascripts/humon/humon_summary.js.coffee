Humon.Summary = Humon.Complex.extend()

Humon.Summary.reopenClass
  childMetatemplates:
    best:
      name: "text"
    worst:
      name: "text"
    happiness:
      name: "number"
    funny:
      name: "text"
    insight:
      name: "text"
    work:
      name: "work"

  requiredAttributes: ["best", "worst", "happiness", "meditation", 'work']
  optionalAttributes: ["funny", "insight"]

Humon.Summary._generateAccessors()

Humon.Meditation = Humon.Complex.extend()
Humon.Meditation.reopenClass
  childMetatemplates:
    activities:
      name: "text"
    satisfaction:
      name: "number"
  requiredAttributes: ["activities", "satisfaction"]


Humon.Work = Humon.Complex.extend()
Humon.Work.reopenClass
  childMetatemplates:
    arrive_at:
      name: "time"
    left_at:
      name: "time"
  requiredAttributes: ['arrived_at', 'left_at']

