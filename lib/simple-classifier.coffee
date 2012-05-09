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
    #@relatedCatCount = {}
    #for category in @categories
      #@relatedCatCount[category] = {}
      #for text, catArray of @relatedCat when category in catArray
        #for relatedCat in catArray when relatedCat != category
          #@relatedCatCount[category][relatedCat] = 0 unless @relatedCatCount[category][relatedCat]?
          #@relatedCatCount[category][relatedCat]++

    #for category, relatedCats of @relatedCatCount
      #total = (count for target, count of relatedCats).reduce (sum, count) ->
        #sum += count
      #, 0.0
      #for relatedCat, count of relatedCats
        #console.log "#{category} is a parent of #{relatedCat}" if count / total > 0.2

    #@parentage = {}
    #for category, relatedCats of @relatedCatCount
      #total = (count for target, count of relatedCats).reduce (sum, count) ->
        #sum += count
      #, 0.0
      #for target, count of relatedCats
        #targetTotal = (count for newTarget, newCount of @relatedCatCount[target]).reduce (sum, count) ->
          #sum += count
        #, 0.0
        #if total > targetTotal
          #@parentage[target] = [] unless @parentage[target]?
          #@parentage[target].push category unless category in @parentage[target]
    #console.log JSON.stringify @parentage, null, 2

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
