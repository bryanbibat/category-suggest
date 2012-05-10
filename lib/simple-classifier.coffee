Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

Stemmer = require('./stemmer').Stemmer

class SimpleClassifier
  constructor: (@categories) ->
    @priorData = []
    @relatedCat = {}
    @loadSynonyms()

  loadSynonyms: ->
    fs = require 'fs'
    @synonyms = JSON.parse(fs.readFileSync("./synonyms.js", "utf8"))

  train: (category, text) ->
    @priorData.push [ Stemmer.getStems(text).unique(), category ]
    @relatedCat[text] = [] unless @relatedCat[text]?
    @relatedCat[text].push category unless category in @relatedCat[text]
  
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
    changed = true
    until changed == false
      changed = false
      for k, v of score when @synonyms[k]?
        for parentCat in @synonyms[k]
          if !score[parentCat]? || score[parentCat] < v
            score[parentCat] = v
            changed = true
    score
       
exports =
  SimpleClassifier: SimpleClassifier

module.exports = exports if module?
