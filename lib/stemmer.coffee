class Stemmer

  @stem: (word) ->
    working = word.toLowerCase()
    working = @removeApostrophe(working)

  @removeApostrophe: (word) ->
    match = word.match /^(\w*)('s?)$/
    return word if match == null
    match[1]

exports =
  Stemmer: Stemmer

module.exports = exports if module?
