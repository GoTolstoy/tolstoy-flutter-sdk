// ignore_for_file: avoid_dynamic_calls

import "dart:convert";
import "dart:io";
import "package:path/path.dart" as path;
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

void main() async {
  debugInfo("Updating tolstoy_flutter_sdk package...");

  // Hardcoded Git URI
  const gitUri = "git@github.com:GoTolstoy/tolstoy-flutter-sdk.git";

  // Get the path to the package
  final packagePath = await getPackagePath();
  if (packagePath == null) {
    debugError(
      "Unable to find the package. Make sure it's properly installed.",
    );
    return;
  }

  debugInfo("Package found at: $packagePath");

  // Pull latest changes
  debugInfo("Pulling latest changes...");
  final pullResult =
      await Process.run("git", ["pull", gitUri], workingDirectory: packagePath);

  if (pullResult.exitCode != 0) {
    debugError("Error pulling latest changes:");
    debugError(pullResult.stderr);
    return;
  }

  // Run pub get
  debugInfo("Running flutter pub get...");
  final pubGetResult = await Process.run("flutter", ["pub", "get"]);

  if (pubGetResult.exitCode != 0) {
    debugError("Error running flutter pub get:");
    debugError(pubGetResult.stderr);
    return;
  }

  debugInfo("Package updated successfully!");
}

Future<String?> getPackagePath() async {
  final packageConfigFile = File(".dart_tool/package_config.json");
  // ignore: avoid_slow_async_io
  if (!await packageConfigFile.exists()) {
    debugError(
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

  debugInfo("tolstoyPackage: $tolstoyPackage");

  if (tolstoyPackage == null) {
    debugError("tolstoy_flutter_sdk package not found in package_config.json.");
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
