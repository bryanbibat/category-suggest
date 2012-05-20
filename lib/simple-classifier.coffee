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
    stemCount = stemsArr.reduce (stemCount, stems) ->
      for stem in stems
        stemCount[stem] = stemCount[stem]? ? stemCount[stem] + 1 : 1
      stemCount
    , {}
    stemCount = ([stem, count] for stem, count of stemCount)
    stemCount.sort (x, y) ->
      x[1] - y[1]

  classify: (text) ->
    ([k, v] for k, v of @classifications(text) when @screenResult(text, v)).sort (x, y) ->
      y[1] - x[1]

  screenResult: (text, hits) ->
      hits >= 2 || (hits == 1 && Stemmer.getStems(text).length == 1)

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
      for category, hits of score when @synonyms[category]?
        for parentCat in @synonyms[category]
          if !score[parentCat]? || score[parentCat] < hits
            score[parentCat] = hits
            changed = true
    score

  baseScoreOnCategories: (text) ->
    @categories.filter( (category) ->
      category.length > 1 && text.indexOf(category.trim()) != -1
    ).reduce (score, category) ->
      score[category] = Stemmer.getStems(text).length
      score
    , {}

  getScore: (trainStems, textStems) ->
    originalLength = textStems.length
    working = (stem for stem in textStems)
    for trainStem in trainStems
      if trainStem in working
        idx = working.indexOf(trainStem)
        working.splice(idx, 1)
    originalLength - working.length
       
exports =
  SimpleClassifier: SimpleClassifier

module.exports = exports if module?
