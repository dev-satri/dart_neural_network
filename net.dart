part of 'main.dart';

///class Net
class Net {
  ///m_layers [layerNum][neuronNum]
  final List<Layer> m_layers = [];
  double m_recentAverageError = 0.0;
  double m_recentAverageSmoothingFactor = 0.0;

  double getRecentAverageError() {
    return m_recentAverageError;
  }

  //GetResults reads the output values and sends it back, it doesnot modify object
  void getResults(List<double> resultVals) {
    resultVals.clear();
    for (int n = 0; n < m_layers.last.length - 1; n++) {
      resultVals.add(m_layers.last[n].getOutputVal());
    }
  }

  //
  void backProp(List<double> targetVals) {
    //Calculate overall net error (RMS - Root Mean Square of output neuron errors)
    Layer outputLayer = m_layers.last;
    double m_error = 0.0;

    for (int n = 0; n < outputLayer.length - 1; n++) {
      double delta = targetVals[n] - outputLayer[n].getOutputVal();
      m_error += delta * delta;
    }
    m_error /= outputLayer.length - 1;
    //Taking square root
    m_error = sqrt(m_error); //RMS

    //Implement a recent average measurement:
    m_recentAverageError =
        (m_recentAverageError * m_recentAverageSmoothingFactor + m_error) /
            (m_recentAverageSmoothingFactor + 1.0);

    //Calculate output layer gradiants
    for (int n = 0; n < outputLayer.length - 1; n++) {
      outputLayer[n].calcOutputGradients(targetVals[n]);
    }

    //Calculate gradients on hidden layers
    for (int layerNum = m_layers.length - 2; layerNum > 0; layerNum--) {
      Layer hiddenLayer = m_layers[layerNum];
      Layer nextLayer = m_layers[layerNum + 1];

      for (int n = 0; n < hiddenLayer.length; n++) {
        hiddenLayer[n].calcHiddenGradients(nextLayer);
      }
    }

    //For all layers from outputs to first hidden layer
    //update connection weights

    for (int layerNum = m_layers.length - 1; layerNum > 0; layerNum--) {
      Layer layer = m_layers[layerNum];
      Layer prevLayer = m_layers[layerNum - 1];
      for (int n = 0; n < layer.length - 1; n++) {
        layer[n].updateInputWeights(prevLayer);
      }
    }
  }

  //
  void feedForward(List<double> inputVals) {
    //verifies that the number of input values is equal to number of neurons
    assert(inputVals.length == m_layers[0].length - 1);

    ///Assign(latch) the input values into the input neurons
    /// i-> input
    for (int i = 0; i < inputVals.length; i++) {
      m_layers[0][i].setOutputVal(inputVals[i]);
    }

    ///Forward propagate
    for (int layerNum = 1; layerNum < m_layers.length; layerNum++) {
      //n-> neuron
      for (int n = 0; n < m_layers[layerNum].length - 1; n++) {
        Layer prevLayer = m_layers[layerNum - 1];
        m_layers[layerNum][n].feedForward(prevLayer);
      }
    }
  }

  //eg: (3,2,1) first layer is input layer with 3 neurons, 1 hidden layer of 2 neurons and 1 output layer of 1 neuron
  Net(this.topology) {
    //numLayers -> Number of layers
    int numLayers = topology.length;
    //Loop
    for (int layerNum = 0; layerNum < numLayers; layerNum++) {
      m_layers.add(<Neuron>[]);
      int numOutputs =
          layerNum == topology.length - 1 ? 0 : topology[layerNum + 1];
      //We have  made a new layer, now fill it with neurons and
      //add bias neuron to the layer
      for (int neuronNum = 0; neuronNum <= topology[layerNum]; neuronNum++) {
        m_layers.last.add(Neuron(numOutputs, neuronNum));
        print('Made a Neuron');
      }

      //Force the bias node's output value to 1.0. It's the last neuron created above
      m_layers.last.last.setOutputVal(1.0);
    }
  }
  final List<int> topology;
}
