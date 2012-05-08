Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

Stemmer = require('./stemmer').Stemmer

class SimpleClassifier
  constructor: (categories) ->
    @priorData = []

  train: (category, text) ->
    @priorData.push [ Stemmer.getStems(text).unique(), category ]
  
  completeTrain: ->
    null

  classify: (text) ->
    ([k, v] for k, v of @classifications(text) when v >= 2).sort (x, y) ->
      y[1] - x[1]

  classifications: (text) ->
    score = {}
    stems = Stemmer.getStems(text).unique()
    for priorData in @priorData
      currentScore = (stem for stem in stems when stem in priorData[0]).length
      if currentScore > 0
        if score[priorData[1]]?
          score[priorData[1]] = currentScore if score[priorData[1]] < currentScore
        else
          score[priorData[1]] = currentScore
    score
       
exports =
  SimpleClassifier: SimpleClassifier

module.exports = exports if module?
