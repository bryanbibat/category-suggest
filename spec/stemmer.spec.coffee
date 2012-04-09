Stemmer = require('../lib/stemmer').Stemmer

describe 'stemmer', ->

  it 'should lowercase words', ->
    expect(Stemmer.prepareWord("ABC")).toBe("abc")
    expect(Stemmer.stem("ABC")).toBe("abc")

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

  it 'should replace sses with ss', ->
    expect(Stemmer.doStep1A("molasses")).toBe("molass")
    expect(Stemmer.doStep1A("molassessy")).toBe("molassessy")

  it 'should replace ies/ied with i/ie', ->
    expect(Stemmer.doStep1A("ties")).toBe("tie")
    expect(Stemmer.doStep1A("cries")).toBe("cri")

  it 'should remove s if preceding word contains a vowel not immediately before s', ->
    expect(Stemmer.doStep1A("gas")).toBe("gas")
    expect(Stemmer.doStep1A("gaps")).toBe("gap")
    expect(Stemmer.doStep1A("kiwis")).toBe("kiwi")

  it 'should replace eed/eedly with ee', ->
    expect(Stemmer.doStep1B("seed", 4)).toBe("seed")
    expect(Stemmer.doStep1B("unseed", 2)).toBe("unsee")
    expect(Stemmer.doStep1B("disagreed", 3)).toBe("disagree")

  it 'should replace ed/edly/ing/ingly with e', ->
    expect(Stemmer.doStep1B("luxuriated", 3)).toBe("luxuriate")
    expect(Stemmer.doStep1B("disabled", 3)).toBe("disable")
    expect(Stemmer.doStep1B("ostracizing", 3)).toBe("ostracize")

  it 'should remove double + ed/edly/ing/ingly', ->
    expect(Stemmer.doStep1B("hopped", 3)).toBe("hop")

  it 'should replace short + ed/edly/ing/ingly with e', ->
    expect(Stemmer.doStep1B("hoped", 3)).toBe("hope")
    expect(Stemmer.doStep1B("hoping", 3)).toBe("hope")

  it 'should know if a word is short or not', ->
    expect(Stemmer.isShort("disagreed", 3)).toBe(false)
    expect(Stemmer.isShort("hop", 3)).toBe(true)
    expect(Stemmer.isShort("shred", 5)).toBe(true)
    expect(Stemmer.isShort("shed", 4)).toBe(true)
    expect(Stemmer.isShort("bead", 4)).toBe(false)
    expect(Stemmer.isShort("embed", 2)).toBe(false)

  it 'should replace ending y with i', ->
    expect(Stemmer.doStep1C("cry")).toBe("cri")
    expect(Stemmer.doStep1C("by")).toBe("by")
    expect(Stemmer.doStep1C("say")).toBe("say")

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
    for testCase in cases
      expect(Stemmer.stem(testCase[0])).toBe(testCase[1])

  it 'should work for conspicuous', ->
    expect(Stemmer.getStartR1("conspicuous")).toBe(3)
    expect(Stemmer.getStartR2("conspicuous", 3)).toBe(7)
    expect(Stemmer.doStep2("conspicuous", 3)).toBe("conspicuous")
    expect(Stemmer.doStep4("conspicuous", 7)).toBe("conspicu")
    expect(Stemmer.stem("conspicuous")).toBe("conspicu")
