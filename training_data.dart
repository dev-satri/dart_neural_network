part of 'main.dart';

class TrainingData {
  final File mTrainingDataFile;
  late List<String> _lines;
  int _currentLine = 0;

  TrainingData(String fileName) : mTrainingDataFile = File(fileName) {
    _lines = mTrainingDataFile
        .readAsLinesSync(); // Read all lines from the file into a list
  }

  bool isEof() {
    // Check if we've reached the end of the lines
    return _currentLine >= _lines.length;
  }

  void getTopology(List<int> topology) {
    String line;
    String label;

    // Read the first line for topology information
    if (isEof()) {
      throw Exception('Error: No data in file');
    }

    line = _lines[_currentLine++];
    var ss = line.split(' ');
    label = ss[0];

    if (label != 'topology:') {
      throw Exception('Error in topology');
    }

    // Extract topology values
    for (var i = 1; i < ss.length; i++) {
      int n = int.tryParse(ss[i]) ?? 0;
      topology.add(n);
    }
  }

  int getNextInputs(List<double> inputVals) {
    inputVals.clear();

    if (isEof()) {
      throw Exception('Error: No more data to read');
    }

    String line = _lines[_currentLine++];
    var ss = line.split(' ');
    String label = ss[0];

    if (label == 'in:') {
      // Collect input values
      for (var i = 1; i < ss.length; i++) {
        double oneValue = double.tryParse(ss[i]) ?? 0.0;
        inputVals.add(oneValue);
      }
    }
    return inputVals.length;
  }

  int getTargetOutputs(List<double> targetOutputVals) {
    targetOutputVals.clear();

    if (isEof()) {
      throw Exception('Error: No more data to read');
    }

    String line = _lines[_currentLine++];
    var ss = line.split(' ');
    String label = ss[0];

    if (label == 'out:') {
      // Collect output values
      for (var i = 1; i < ss.length; i++) {
        double oneValue = double.tryParse(ss[i]) ?? 0.0;
        targetOutputVals.add(oneValue);
      }
    }
    return targetOutputVals.length;
  }
}
