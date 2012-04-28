Csv = require('ya-csv')
BayesClassifier = require('./bayes-classifier').BayesClassifier

class CategorySuggest
  constructor: (@categoryFile, @trainFile, @competitionFile, @resultFile) ->
    @categories = []

  execute: ->
    @readCategories()

  readCategories: ->
    reader = Csv.createCsvFileReader(@categoryFile)
    reader.setColumnNames ['title']
    reader.addListener 'data', (data) =>
      @categories.push data.title unless data.title in @categories
    reader.addListener 'end', =>
      @classifier = new BayesClassifier(@categories)
      @readTrainingSet()

  readTrainingSet: ->
    reader = Csv.createCsvFileReader(@trainFile)
    reader.setColumnNames ['title', 'category']
    reader.addListener 'data', (data) =>
      if data.category in @categories
        product = data.title.toLowerCase()
        @classifier.train data.category, product
    reader.addListener 'end', =>
      @processCompetitionSet()

  processCompetitionSet: ->
    reader = Csv.createCsvFileReader(@competitionFile, { columnsFromHeader: true })
    writer = new Csv.createCsvFileWriter(@resultFile)
    writer.writeRecord ["title", "category"]
    reader.addListener 'data', (data) =>
      for result in @classifier.classify(data.title)
        writer.writeRecord [data.title, result[0]]
        console.log "#{data.title} :: #{result[0]} :: #{(result[1] * 100).toFixed(2)}%"
    reader.addListener 'end', =>
      console.log "Competition set processed. Results can be found in #{@resultFile}"
exports =
  CategorySuggest: CategorySuggest

module.exports = exports if module?
