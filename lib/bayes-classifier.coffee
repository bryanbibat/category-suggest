Stemmer = require('./stemmer').Stemmer

class BayesClassifier
  constructor: (categories) ->
    @categories = categories.reduce((hash, cat) ->
      hash[cat] = {}
      hash
    , {})
    @totalWords = 0

  train: (category, text) ->
    for stem in Stemmer.getStems(text)
      if @categories[category][stem]?
        @categories[category][stem]++
      else
        @categories[category][stem] = 1
      @totalWords++

  classify: (text) ->
    #console.log @classifications(text)
    ([k, v] for k, v of @classifications(text) when v >= 0.5).sort (x, y) ->
      y[1] - x[1]

  classifications: (text) ->
    score = {}
    for category, catWords of @categories when @containsWords(catWords, text)
      score[category] = 0
      total = (count for word, count of catWords).reduce (sum, count) ->
        sum += count
      , 0
      for stem in Stemmer.getStems(text)
        s = if catWords[stem]? then catWords[stem] else 0.1
        score[category] += Math.log s/total
    for k, v of score
      score[k] = Math.exp(score[k] / Math.exp(2))
    score

  containsWords: (catWords, text) ->
    words = (word for word, count of catWords)
    includes = false
    for stem in Stemmer.getStems(text)
      includes = true if stem in words
    includes

exports =
  BayesClassifier: BayesClassifier

module.exports = exports if module?
