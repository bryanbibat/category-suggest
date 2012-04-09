Stemmer = require('../lib/stemmer').Stemmer

describe 'stemmer', ->

  it 'should lowercase words', ->
    expect(Stemmer.prepareWord("ABC")).toBe("abc")

  it 'should remove apostrophes', ->
    expect(Stemmer.removeApostrophe("a'bc")).toBe("a'bc")
    expect(Stemmer.removeApostrophe("bryan's")).toBe("bryan")
    expect(Stemmer.removeApostrophe("jesus'")).toBe("jesus")

  it 'should calculate Region 1', ->
    expect(Stemmer.getStartR1("mad")).toBe(3)
    expect(Stemmer.getStartR1("madenning")).toBe(3)
    expect(Stemmer.getStartR1("stemmer")).toBe(4)

  it 'should calculate Region 2', ->
    expect(Stemmer.getStartR2("madenning", 3)).toBe(5)
    expect(Stemmer.getStartR2("stemmer", 4)).toBe(7)
    expect(Stemmer.getStartR2("conditional", 3)).toBe(6)

  it 'should replace Ys', ->
    expect(Stemmer.changeY("yes")).toBe("Yes")
    expect(Stemmer.changeY("day")).toBe("daY")
    expect(Stemmer.changeY("mayday")).toBe("maYdaY")

  it 'should pass the sample vocabulary', ->
    cases = [
      ["consign", "consign"]
      ["consigned", "consign"]
      ["consigning", "consign"]
      ["consignment", "consign"]
      ["consist", "consist"]
      ["consisted", "consist"]
      ["consistency", "consist"]
      ["consistent", "consist"]
      ["consistently", "consist"]
      ["consisting", "consist"]
      ["consists", "consist"]
      ["consolation", "consol"]
      ["consolations", "consol"]
      ["consolatory", "consolatori"]
      ["console", "consol"]
      ["consoled", "consol"]
      ["consoles", "consol"]
      ["consolidate", "consolid"]
      ["consolidated", "consolid"]
      ["consolidating", "consolid"]
      ["consoling", "consol"]
      ["consolingly", "consol"]
      ["consols", "consol"]
      ["consonant", "conson"]
      ["consort", "consort"]
      ["consorted", "consort"]
      ["consorting", "consort"]
      ["conspicuous", "conspicu"]
      ["conspicuously", "conspicu"]
      ["conspiracy", "conspiraci"]
      ["conspirator", "conspir"]
      ["conspirators", "conspir"]
      ["conspire", "conspir"]
      ["conspired", "conspir"]
      ["conspiring", "conspir"]
      ["constable", "constabl"]
      ["constables", "constabl"]
      ["constance", "constanc"]
      ["constancy", "constanc"]
      ["constant", "constant"]
      ["knack", "knack"]
      ["knackeries", "knackeri"]
      ["knacks", "knack"]
      ["knag", "knag"]
      ["knave", "knave"]
      ["knaves", "knave"]
      ["knavish", "knavish"]
      ["kneaded", "knead"]
      ["kneading", "knead"]
      ["knee", "knee"]
      ["kneel", "kneel"]
      ["kneeled", "kneel"]
      ["kneeling", "kneel"]
      ["kneels", "kneel"]
      ["knees", "knee"]
      ["knell", "knell"]
      ["knelt", "knelt"]
      ["knew", "knew"]
      ["knick", "knick"]
      ["knif", "knif"]
      ["knife", "knife"]
      ["knight", "knight"]
      ["knightly", "knight"]
      ["knights", "knight"]
      ["knit", "knit"]
      ["knits", "knit"]
      ["knitted", "knit"]
      ["knitting", "knit"]
      ["knives", "knive"]
      ["knob", "knob"]
      ["knobs", "knob"]
      ["knock", "knock"]
      ["knocked", "knock"]
      ["knocker", "knocker"]
      ["knockers", "knocker"]
      ["knocking", "knock"]
      ["knocks", "knock"]
      ["knopp", "knopp"]
      ["knot", "knot"]
      ["knots", "knot"]
    ]
    #for testCase in cases
      #expect(Stemmer.stem(testCase[0])).toBe(testCase[1])
