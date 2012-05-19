Stemmer = require('./stemmer').Stemmer

class SimpleClassifier
  constructor: (@categories) ->
    @priorData = []
    @loadSynonyms()

  loadSynonyms: ->
    fs = require 'fs'
    @synonyms = JSON.parse(fs.readFileSync("./synonyms.js", "utf8"))

  train: (category, text) ->
    @priorData.push [ Stemmer.getStems(text), category ]
  
  completeTrain: ->
    stemsArr = (data[0] for data in @priorData)
    stemCount = {}
    for stems in stemsArr
      for stem in stems
        unless stemCount[stem]?
          stemCount[stem] = 0
        stemCount[stem]++
    stemCount = ([stem, count] for stem, count of stemCount)
    stemCount.sort (x, y) ->
      x[1] - y[1]

  classify: (text) ->
    ([k, v] for k, v of @classifications(text) when @screenResult(text, v)).sort (x, y) ->
      y[1] - x[1]

  screenResult: (text, v) ->
      v >= 2 || (v == 1 && Stemmer.getStems(text).length == 1)

  classifications: (text) ->
    score = @baseScoreOnCategories(text)
    stems = Stemmer.getStems(text)
    for priorData in @priorData
      currentScore = @getScore(priorData[0], stems)
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

  baseScoreOnCategories: (text) ->
    score = {}
    for category in @categories when category.length > 1
      if text.indexOf(category.trim()) != -1
        score[category] = Stemmer.getStems(text).length
    score

  getScore: (trainStems, textStems) ->
    originalLength = textStems.length
    working = (stem for stem in textStems)
    for trainStem in trainStems
      if trainStem in working
        idx = working.indexOf(trainStem)
        working.splice(idx, 1)
    #if (stem for stem in trainStems when stem in textStems).length > 0
      #console.log "[#{trainStems}] [#{textStems}] [#{working}]"
      #console.log originalLength - textStems.length
    originalLength - working.length
       
exports =
  SimpleClassifier: SimpleClassifier

module.exports = exports if module?
