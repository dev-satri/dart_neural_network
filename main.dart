//neural network
//our nets are fully and implicitly connected with a bias for each neuron
//
import 'dart:io';
import 'dart:math';
part 'connection.dart';
part 'neuron.dart';
part 'training_data.dart';
part 'net.dart';

typedef Layer = List<Neuron>;

void showVectorVals(String label, List<double> v) {
  List<double> value = [];
  for (var val in v) {
    value.add(val);
  }
  print('$label : $value');
}

void main() {
  TrainingData trainingData = TrainingData('trainingData.txt');
  List<int> topology = [];
  trainingData.getTopology(topology);

  // Simulating Net class since it's not defined in the original code
  var myNet = Net(topology);
  List<double> inputVals = [];
  List<double> targetVals = [];
  List<double> resultVals = [];
  int trainingPass = 0;

  while (!trainingData.isEof()) {
    trainingPass++;
    print('Pass: $trainingPass');
    if (trainingData.getNextInputs(inputVals) != topology[0]) {
      break;
    }
    showVectorVals('Inputs: ', inputVals);
    myNet.feedForward(inputVals);

    trainingData.getTargetOutputs(targetVals);
    showVectorVals('Targets: ', targetVals);

    // Collect the net's actual results:
    myNet.getResults(resultVals);
    showVectorVals('Output: ', resultVals);

    if (targetVals.length != topology.last) {
      throw Exception('Target length mismatch');
    }

    myNet.backProp(targetVals);

    // Report how well the training is working
    print('Net recent average error: ${myNet.getRecentAverageError()}');
    print('\n');
  }

  print('Done');
}
