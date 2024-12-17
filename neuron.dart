part of 'main.dart';

//class Neuron
class Neuron {
  final int numOutputs;
  final int myIndex;
  int m_myIndex = 0;
  double m_outputVal = 0.0;
  double m_gradient = 0.0;
  //TODO(Sangam): eta and alpha are tunable parameters look into keyword.png
  double eta = 0.15; //[0.0...1.0] overall net training rate
  double alpha = 0.5; //[0.0...n] multiplier of last weight change (momentum)

  List<Connection> m_outputWeights = [];

  void updateInputWeights(Layer prevLayer) {
    //The weights to be updated are in the Connection container
    //in the neurons in the preceding layer
    for (int n = 0; n < prevLayer.length; n++) {
      Neuron neuron = prevLayer[n];
      double oldDeltaWeight = neuron.m_outputWeights[m_myIndex].deltaWeight;

      double newDeltaWeight =
          //Individual input, magnified by the gradient and train rate:
          eta * neuron.getOutputVal() * m_gradient
              //Also add momentum = a fraction of the previous delta weight
              +
              alpha * oldDeltaWeight;

      neuron.m_outputWeights[m_myIndex].deltaWeight = newDeltaWeight;
      neuron.m_outputWeights[m_myIndex].weight += newDeltaWeight;
    }
  }

  double sumDOW(Layer nextLayer) {
    double sum = 0.0;
    //Sum our contributions of the errors at the node we feed
    for (int n = 0; n < nextLayer.length - 1; n++) {
      sum += m_outputWeights[n].weight * nextLayer[n].m_gradient;
    }
    return sum;
  }

  void calcOutputGradients(double targetVal) {
    double delta = targetVal - m_outputVal;
    m_gradient = delta * transferFunctionDerivative(m_outputVal);
  }

  void calcHiddenGradients(Layer nextLayer) {
    double dow = sumDOW(nextLayer);
    m_gradient = dow * transferFunctionDerivative(m_outputVal);
  }

  void setOutputVal(double val) {
    m_outputVal = val;
  }

  double getOutputVal() => m_outputVal;

  double tanh(double x) {
    return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
  }

  double transferFunction(double x) {
    return tanh(x);
  }

  double transferFunctionDerivative(double x) {
    //tanh derivative
    return 1.0 - x * x;
  }

  double randomWeight() {
    Random random = Random();
    return random.nextDouble();
  }

  void feedForward(Layer prevLayer) {
    double sum = 0.0;
    //Sum the previous layer's outputs (which are our outputs)
    //Include the bias node from the previous layer
    for (int n = 0; n < prevLayer.length; n++) {
      sum += prevLayer[n].getOutputVal() *
          prevLayer[n].m_outputWeights[m_myIndex].weight;
    }

    m_outputVal = transferFunction(sum);
  }

  Neuron(this.numOutputs, this.myIndex) {
    //c-> connections
    for (int c = 0; c < numOutputs; c++) {
      m_outputWeights.add(Connection());
      m_outputWeights.last.weight = randomWeight();
    }

    m_myIndex = myIndex;
  }
}
