Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

Stemmer = require('./stemmer').Stemmer

class BayesClassifier
  constructor: (categories) ->
    @categories = categories.reduce((hash, cat) ->
      hash[cat] = {}
      hash
    , {})
    @exactCategories = {}
    @usedCategories = {}
    @stems = {}
    @totalWords = 0

  train: (category, text) ->
    @exactCategories[text] = {} unless @exactCategories[text]?
    @exactCategories[text][category] = true
    @usedCategories[category] = true
    for stem in Stemmer.getStems(text).unique()
      if @categories[category][stem]?
        @categories[category][stem]++
      else
        @categories[category][stem] = 1
      if @stems[stem]?
        @stems[stem]++
      else
        @stems[stem] = 1
      @totalWords++
  
  completeTrain: ->
    for category, v of @usedCategories
      @train(category, category)

  classify: (text) ->
    #console.log @classifications(text)
    ([k, v] for k, v of @classifications(text) when v >= 0.1).sort (x, y) ->
      y[1] - x[1]

  classifications: (text) ->
    score = {}
    for category, catWords of @categories when @containsWords(catWords, text)
      score[category] = 0
      continue if @exactWords(category, text)
      total = (count for word, count of catWords).reduce (sum, count) ->
        sum += count
      , 0
      for stem in Stemmer.getStems(text)
        s = if catWords[stem]? then catWords[stem] else 0.005
        score[category] += Math.log(s/total)
    for k, v of score
      score[k] = Math.exp(score[k] / Math.exp(2))
    score

  containsWords: (catWords, text) ->
    words = (word for word, count of catWords)
    includes = false
    for stem in Stemmer.getStems(text)
      includes = true if stem in words
    includes

  exactWords: (category, text) ->
    text = text.toLowerCase()
    @exactCategories[text]? && @exactCategories[text][category]?

  stemCounts: ->
    ([k, v] for k, v of @stems).sort (x, y) ->
      x[1] - y[1]
       
exports =
  BayesClassifier: BayesClassifier

module.exports = exports if module?
