CategorySuggest = require('./lib/category-suggest').CategorySuggest

cs = new CategorySuggest("./categories.csv", "./trainingset.csv", "./competitionset.csv", "./result.csv")

cs.execute()
