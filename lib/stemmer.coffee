class Stemmer

  @stem: (word) ->
    word = @prepareWord(word)
    return word if word.length <= 2
    word = @changeY(word)
    startR1 = @getStartR1(word)
    startR2 = @getStartR2(word, startR1)
    word = @removeApostrophe(word)
    word = @doStep1A(word)
    word = @doStep1B(word, startR1)
    word.replace(/Y/g, "y")

  @prepareWord: (word) ->
    word = word.toLowerCase()
    if word.charAt(1) == "'" then word.slice(1) else word

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
    word = "Y" + word.slice(1) if word.charAt(0) == "y"
    word.replace(/([aeiou])y/g, "$1Y")

  @removeApostrophe: (word) ->
    match = word.match /^(\w*)('s?)$/
    return word if match == null
    match[1]

  @doStep1A: (word) ->
    if word.match /sses$/
      return word.replace /(\w*)sses$/, "$1ss"
    if word.match /(\w*)(ied|ies)$/
      if word.match(/(\w*)(ied|ies)$/)[1].length > 1
        return word.replace /(\w*)(ied|ies)$/, "$1i"
      else
        return word.replace /(\w*)(ied|ies)$/, "$1ie"
    return word if word.match(/(\w*)ss$/)
    if word.match(/\w*?[aeiouy]\w+s$/)
      return word.slice(0, word.length - 1)
    word

  @doStep1B: (word, startR1) ->
    if word.search(/(eed|eedly)$/) > startR1
      return word.replace(/(\w*)(eed|eedly)/, "$1ee")
    if word.match(/\w*?[aeiouy]\w+(ed|edly|ing|ingly)$/)
      word = word.match(/^(\w*?[aeiouy]\w+)(ed|edly|ing|ingly)$/)[1]
      return word + "e" if word.match(/(at|bl|iz)$/)
      if word.match(/(bb|dd|ff|gg|mm|nn|pp|rr|tt)$/)
        return word.slice(0, word.length - 1)
      return word + "e" if @isShort(word, startR1)
    word

  @isShort: (word, startR1) ->
    word.match(/^([aeouiy][^aeouiy]|\w*[^aeiouy][aeouiy][^aeouiyYwx])$/) != null and startR1 >= word.length

exports =
  Stemmer: Stemmer

module.exports = exports if module?
