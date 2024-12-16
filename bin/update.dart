// ignore_for_file: avoid_dynamic_calls, avoid_print

import "dart:convert";
import "dart:io";

import "package:path/path.dart" as path;

void main() async {
  print("Updating tolstoy_flutter_sdk package...");

  // Hardcoded Git URI
  const String gitUri = "git@github.com:GoTolstoy/tolstoy-flutter-sdk.git";

  // Get the path to the package
  final packagePath = await getPackagePath();
  if (packagePath == null) {
    print("Unable to find the package. Make sure it's properly installed.");
    return;
  }

  print("Package found at: $packagePath");

  // Pull latest changes
  print("Pulling latest changes...");
  final pullResult =
      await Process.run("git", ["pull", gitUri], workingDirectory: packagePath);

  if (pullResult.exitCode != 0) {
    print("Error pulling latest changes:");
    print(pullResult.stderr);
    return;
  }

  // Run pub get
  print("Running flutter pub get...");
  final pubGetResult = await Process.run("flutter", ["pub", "get"]);

  if (pubGetResult.exitCode != 0) {
    print("Error running flutter pub get:");
    print(pubGetResult.stderr);
    return;
  }

  print("Package updated successfully!");
}

Future<String?> getPackagePath() async {
  final packageConfigFile = File(".dart_tool/package_config.json");
  // ignore: avoid_slow_async_io
  if (!await packageConfigFile.exists()) {
    print(
      "package_config.json not found. Make sure you're in the root of your Flutter project.",
    );
    return null;
  }

  final packageConfig = jsonDecode(await packageConfigFile.readAsString());
  final packages = packageConfig["packages"] as List;
  final tolstoyPackage = packages.firstWhere(
    (package) => package["name"] == "tolstoy_flutter_sdk",
    orElse: () => null,
  );

  print("tolstoyPackage: $tolstoyPackage");

  if (tolstoyPackage == null) {
    print("tolstoy_flutter_sdk package not found in package_config.json.");
    return null;
  }

  final packageUri = tolstoyPackage["rootUri"] as String;
  if (packageUri.startsWith("file:")) {
    return Uri.parse(packageUri).toFilePath();
  } else {
    final projectRoot = path.dirname(path.dirname(packageConfigFile.path));
    return path.normalize(path.join(projectRoot, packageUri));
  }
}
