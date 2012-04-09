class Stemmer

  @stem: (word) ->
    working = @prepareWord(word)
    return working if working.length <= 2
    working = @changeY(working)
    startR1 = @getStartR1(working)
    startR2 = @getStartR2(working, startR1)
    working = @removeApostrophe(working)

  @prepareWord: (word) ->
    working = word.toLowerCase()
    working = working.slice(1) if working.charAt(1) == "'"
    working

  @getStartR1: (word) ->
    startR1 = word.search(/[aeiouy][^aeiouy]/)
    if startR1 == -1 then word.length else startR1 + 2

  @getStartR2: (word, startR1) ->
    return startR1 if startR1 == word.length
    r1 = word.slice(startR1)
    startR2 = r1.search(/[aeiouy][^aeiouy]/)
    if startR2 == -1 then word.length else startR1 + startR2 + 2

  @changeY: (word) ->
    return word if word.indexOf("y") == -1
    working = word
    working = "Y" + working.slice(1) if working.charAt(0) == "y"
    working.replace(/([aeiou])y/g, "$1Y")

  @removeApostrophe: (word) ->
    match = word.match /^(\w*)('s?)$/
    return word if match == null
    match[1]

exports =
  Stemmer: Stemmer

module.exports = exports if module?
