NeuralNetwork = require('../lib/neural_network').NeuralNetwork

Array::shuffle = -> @sort -> 0.5 - Math.random()

describe 'neural-network', ->

  it 'should handle basic NOT', ->
    neg = new NeuralNetwork(1, 10, 1)

    for x in [1..10000]
      if Math.random() > 0.5
        neg.train([0],[1])
      else
        neg.train([1],[0])
    
    neg.feedforward([0])
    expect(neg.currentOutputs()[0]).toBeGreaterThan(0.98)
    neg.feedforward([1])
    expect(neg.currentOutputs()[0]).toBeLessThan(0.2)

  it 'should properly handle XOR', ->
    xor = new NeuralNetwork(2, 20, 1)

    for x in [1..10000]
      for arr in [[0.0, 0.0, 0.0], [0.0, 1.0, 1.0], [1.0, 0.0, 1.0], [1.0, 1.0, 0.0]].shuffle()
        xor.train([arr[0], arr[1]], [arr[2]])

    xor.feedforward([0, 0])
    expect(xor.currentOutputs()[0]).toBeLessThan(0.01)
    xor.feedforward([0, 1])
    expect(xor.currentOutputs()[0]).toBeGreaterThan(0.99)
    xor.feedforward([1, 0])
    expect(xor.currentOutputs()[0]).toBeGreaterThan(0.99)
    xor.feedforward([1, 1])
    expect(xor.currentOutputs()[0]).toBeLessThan(0.01)
