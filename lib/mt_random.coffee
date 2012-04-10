class MtRandom

  constructor: (seed) ->
    seed = (new Date()).getTime() if not seed?
    @mt = [seed]
    @idx = 0
    for i in [1..623]
      @mt.push(((1812433253 * Number(@mt[i - 1] ^ (@mt[i - 1] >>> 30)) + i) & 0xFFFFFFFF) >>> 0)

  generateNumbers: ->
    for i in [0..623]
      y = (@mt[@idx] & 0x80000000) | (@mt[(@idx + 1) % 624] & 0x7fffffff)
      @mt[@idx] = @mt[(@idx + 397) % 624] ^ (y >>> 1)
      if y % 2 != 0
        @mt[@idx] = @mt[@idx] ^ 0x9908b0df

  rand: ->
    @generateNumbers() if @idx == 0

    y = @mt[@idx]
    y ^= y >>> 11
    y ^= (y << 7) & 0x9d2c5680
    y ^= (y << 15) & 0xefc60000
    y ^= y >>> 18

    @idx = (@idx + 1) % 624
    y * (1.0/2147483648.0)

exports =
  MtRandom: MtRandom

module.exports = exports if module?
