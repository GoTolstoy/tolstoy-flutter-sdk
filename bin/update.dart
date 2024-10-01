import 'dart:io';

void main() async {
  print('Updating package...');

  // Get the path to the package
  final result = await Process.run('flutter', ['pub', 'deps', '--style=compact']);
  final lines = result.stdout.toString().split('\n');
  final packageLine = lines.firstWhere((line) => line.contains('tolstoy_flutter_sdk'), orElse: () => '');
  final packagePath = packageLine.split(' ').last;

  if (packagePath.isEmpty) {
    print('Package not found. Make sure it\'s properly installed.');
    return;
  }

  // Pull latest changes
  print('Pulling latest changes...');
  await Process.run('git', ['pull'], workingDirectory: packagePath);

  // Run pub get
  print('Running flutter pub get...');
  await Process.run('flutter', ['pub', 'get']);

  print('Package updated successfully!');
}