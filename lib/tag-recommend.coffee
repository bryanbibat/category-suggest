Csv = require('ya-csv')
Stemmer = require('./stemmer').Stemmer
NeuralNetwork = require('./neural_network').NeuralNetwork
MtRandom = require("./mt_random").MtRandom

class TagRecommend
  constructor: (@category_file, @train_file, @competition_file) ->
    @realCategories = []
    @realCatLookup = {}
    @categories = []
    @catLookup = {}
    @products = {}
    @productStems = []
    @stemLookup = {}

  execute: ->
    @readCategories()

  readCategories: ->
    reader = Csv.createCsvFileReader(@category_file, { columnsFromHeader: true })
    reader.addListener 'data', (data) =>
      @catLookup[data.title] = @categories.length
      @categories.push data.title
    reader.addListener 'end', =>
      @readTrainingSet()

  readTrainingSet: ->
    reader = Csv.createCsvFileReader(@train_file, { columnsFromHeader: true })
    reader.addListener 'data', (data) =>
      product = data.title.toLowerCase()
      if product of @products
        @addRealCategory(data.category)
        unless data.category in @products[product].categories
          @products[product].categories.push data.category
      else
        #console.log data.category in @realCategories
        stems = @getStems(product)
        @addStems(stems)
        @products[product] =
          categories: [data.category]
          stems: stems
        @addRealCategory(data.category)
    reader.addListener 'end', =>
      #console.log "#{@realCategories.length} #{@categories.length}"
      @dump()

  getStems: (product) ->
    exclusionList = ["", ",", "/", "&", "of", "the", "by", "a", "*", "-", "'", "'s", "=", ">", "s'", "\"", "~"]
    stems = (Stemmer.stem(word) for word in product.split /[ ,()!:@\/]/)
    (word for word in stems when word not in exclusionList and word.search(/^[\d]+(\.[\d]+)?"?$/) == -1)

  addStems: (words) ->
    for word in words when word not in @productStems
      @stemLookup[word] = @productStems.length
      @productStems.push word

  addRealCategory: (category) ->
    unless category in @realCategories
      @realCatLookup[category] = @realCategories.length
      @realCategories.push category

  dump: ->
    fs = require("fs")
    fs.writeFile "test.txt", (stem for stem in @productStems).join("\n")
      

  train: ->
    trainingSet = []
    for product, details of @products
      input = (0 for stem in @productStems)
      input[@stemLookup[stem]] = 1 for stem in details.stems
        
      output = (0 for category in @realCategories)
      output[@realCatLookup[category]] = 1 for category in details.categories

      trainingSet.push [input, output]

    console.log trainingSet.length

    @neuralNetwork = new NeuralNetwork(
      @productStems.length,
      100,
      @realCategories.length,
      42
    )

    for x in [1..1]
      for data, i in trainingSet
        console.log i
        @neuralNetwork.train(data[0], data[1])

exports =
  TagRecommend: TagRecommend

module.exports = exports if module?
