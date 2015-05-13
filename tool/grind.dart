import 'dart:io';

import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
void analyze() {
  new PubApp.global('tuneup')..run(['check']);
}

@DefaultTask()
@Depends(analyze, test, coverage)
void buildbot() => null;

@Task('Gather and send coverage data.')
void coverage() {
  final String coverageToken = Platform.environment['REPO_TOKEN'];
  if (coverageToken != null) {
    PubApp coverallsApp = new PubApp.global('dart_coveralls');
    coverallsApp.run([
      'report',
      '--token', coverageToken,
      '--retry', '2',
      '--exclude-test-files',
      'test/all.dart'
    ]);
  } else {
    log('Skipping coverage task: no environment variable `REPO_TOKEN` found.');
  }
}

@Task()
void test() {
  Tests.runCliTests();
}
