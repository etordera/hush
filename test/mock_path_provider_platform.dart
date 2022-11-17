import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Mock with MockPlatformInterfaceMixin implements PathProviderPlatform {
  String path;
  List<String> paths;

  MockPathProviderPlatform({this.path}) {
    paths = List<String>();
    paths.add(path);
  }

  @override
  Future<String> getApplicationDocumentsPath() async {
    return path;
  }

  @override
  Future<String> getApplicationSupportPath() async {
    return path;
  }

  @override
  Future<String> getDownloadsPath() async {
    return path;
  }

  @override
  Future<List<String>> getExternalCachePaths() async {
    return paths;
  }

  @override
  Future<String> getExternalStoragePath() async {
    return path;
  }

  @override
  Future<List<String>> getExternalStoragePaths({StorageDirectory type}) async {
    return paths;
  }

  @override
  Future<String> getLibraryPath() async {
    return path;
  }

  @override
  Future<String> getTemporaryPath() async {
    return path;
  }
}
