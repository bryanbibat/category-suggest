class Synapse
  constructor: (@sourceNeuron, @destNeuron) ->
    @prevWeight = @weight = (Math.random() * 2.0) - 1.0

class Neuron
  learningRate: 1.0
  momentum: 0.5

  constructor: ->
    @synapsesIn = []
    @synapsesOut = []
    @prevThreshold = @threshold = (Math.random() * 2.0) - 1.0

  calculateOutput: ->
    activation = (@synapsesIn.reduce (sum, synapse) ->
      sum + synapse.weight * synapse.sourceNeuron.output
    , 0.0)
    activation -= @threshold
    @output = 1.0 / (1.0 + Math.exp(-activation))

  derivative: ->
    @output * (1 - @output)

  outputTrain: (rate, target) ->
    @error = (target - @output) * @derivative()
    @updateWeights(rate)

  hiddenTrain: (rate) ->
    @error = @derivative() * (@synapsesOut.reduce (sum, synapse) ->
      sum + synapse.prevWeight * synapse.destNeuron.error
    , 0.0)
    @updateWeights(rate)

  updateWeights: (rate) ->
    for synapse in @synapsesIn
      temp = synapse.weight
      synapse.weight += (rate * @learningRate * @error * synapse.sourceNeuron.output) +
        (@momentum * (synapse.weight - synapse.prevWeight))
      synapse.prevWeight = temp

    temp = @threshold
    @threshold += (@momentum * (@threshold - @prevThreshold)) - (rate * @learningRate * @error)
    @prevThreshold = temp

class NeuralNetwork
  constructor: (inputs, hidden, outputs) ->
    @inputLayer = (new Neuron for [1..inputs])
    @hiddenLayer = (new Neuron for [1..hidden])
    @outputLayer = (new Neuron for [1..outputs])

    for inputNeuron in @inputLayer
      for hiddenNeuron in @hiddenLayer
        synapse = new Synapse(inputNeuron, hiddenNeuron)
        inputNeuron.synapsesOut.push synapse
        hiddenNeuron.synapsesIn.push synapse

    for hiddenNeuron in @hiddenLayer
      for outputNeuron in @outputLayer
        synapse = new Synapse(hiddenNeuron, outputNeuron)
        hiddenNeuron.synapsesOut.push synapse
        outputNeuron.synapsesIn.push synapse

  train: (inputs, targets) ->
    @feedforward(inputs)
    rate = 0.5
    neuron.outputTrain(rate, targets[idx]) for neuron, idx in @outputLayer
    neuron.hiddenTrain(rate) for neuron in @hiddenLayer

  feedforward: (inputs) ->
    neuron.output = inputs[idx] for neuron, idx in @inputLayer
    neuron.calculateOutput() for neuron in @hiddenLayer
    neuron.calculateOutput() for neuron in @outputLayer

  currentOutputs: -> (neuron.output for neuron in @outputLayer)

exports =
  NeuralNetwork: NeuralNetwork

module.exports = exports if module?