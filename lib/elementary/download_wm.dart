import 'dart:async';

import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:request_queue_and_completer/elementary/download_widget.dart';

abstract class IDownloadWm extends IWidgetModel {
  ValueNotifier<List<Status>> get filesStatus;
  int get filesNumber;
  void onAction();
}

class DownloadWm extends WidgetModel<DownloadScreen, DownloadModel>
    implements IDownloadWm {
  final Dio _dio;
  final String _url =
      'http://cdn01.foxitsoftware.com/pub/foxit/manual/ru_ru/FoxitReader60_Manual.pdf';
  final _filesNumber = 6;
  final _filesStatus = ValueNotifier<List<Status>>([]);

  @override
  ValueNotifier<List<Status>> get filesStatus => _filesStatus;

  @override
  int get filesNumber => _filesNumber;

  Completer<bool>? _asyncTask;

  DownloadWm(DownloadModel model, this._dio) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _filesStatus.value = [
      for (int i = 0; i < _filesNumber; i++) Status.notStarted,
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> onAction() async {
    _filesStatus.value = [
      for (int i = 0; i < _filesNumber; i++) Status.notStarted,
    ];
    await Future.wait([for (int i = 0; i < _filesNumber; i++) _task(i)]);
  }

  Future<void> _task(int index) async {
    _filesStatus.value[index] = Status.loading;
    _filesStatus.notifyListeners();

    final result = await _downloadBigFile();
    debugPrint('Finish Task => $result');

    _filesStatus.value[index] = Status.done;
    _filesStatus.notifyListeners();
  }

  Future<bool> _downloadBigFile() async {
    debugPrint('Start downloadBigFile func');

    if (_asyncTask?.isCompleted ?? false) {
      debugPrint('Completer is completed');
      _asyncTask = null;
    }

    if (_asyncTask == null) {
      _asyncTask = Completer<bool>();

      debugPrint('Start downloading big file');
      await _dio.get<String>(_url);

      debugPrint('Delay 5 sec');
      await Future<void>.delayed(const Duration(seconds: 5));

      debugPrint('Done');
      _asyncTask!.complete(true);
    }

    return _asyncTask!.future;
  }
}

class DownloadModel extends ElementaryModel {}

DownloadWm networkImageWmFactory(BuildContext context) {
  final dio = Dio();

  final model = DownloadModel();
  return DownloadWm(model, dio);
}

enum Status { notStarted, loading, done }
