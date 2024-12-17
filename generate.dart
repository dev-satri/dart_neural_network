import 'dart:io';
import 'dart:math';

//Code to generate training Data - The data it generates is to train out neural network for XOR
void main() async {
  // Define XOR function
  double xor(double a, double b) {
    return a != b ? 1.0 : 0.0;
  }

  // Number of data points required
  int numSamples = 2000;

  // Random number generator
  Random rand = Random();

  // Create a file to write the data
  File file = File('trainingdata.txt');
  IOSink sink = file.openWrite();

  // Write the topology once at the top
  sink.writeln('topology: 2 4 1');

  // Generate the training data
  for (int i = 0; i < numSamples; i++) {
    // Generate random binary inputs (0.0 or 1.0)
    double input1 = rand.nextBool() ? 1.0 : 0.0;
    double input2 = rand.nextBool() ? 1.0 : 0.0;

    // Calculate XOR output
    double output = xor(input1, input2);

    // Write the data in the desired format
    sink.writeln('in: $input1 $input2');
    sink.writeln('out: $output');
  }

  // Close the file after writing
  await sink.flush();
  await sink.close();

  print('Training data has been written to trainingdata.txt');
}
