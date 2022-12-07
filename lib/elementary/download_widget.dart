import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:request_queue_and_completer/elementary/download_wm.dart';

class DownloadScreen extends ElementaryWidget<IDownloadWm> {
  const DownloadScreen({
    Key? key,
    WidgetModelFactory<DownloadWm> wmFactory = networkImageWmFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IDownloadWm wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Completer and many the same requests example',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: ValueListenableBuilder<List<Status>>(
        valueListenable: wm.filesStatus,
        builder: (_, filesStatus, __) => Column(
          children: [
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  for (int i = 0; i < wm.filesNumber; i++)
                    DownloadDocument(
                      fileStatus: filesStatus[i],
                      func: wm.onAction,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: wm.onAction,
                child: const Text('Download'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadDocument extends StatelessWidget {
  final Status fileStatus;
  final void Function() func;

  const DownloadDocument({
    required this.fileStatus,
    required this.func,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: Colors.amber,
      height: 100,
      child: Column(
        children: [
          if (fileStatus == Status.notStarted)
            const Expanded(child: Icon(Icons.not_started_outlined)),
          if (fileStatus == Status.loading)
            const Expanded(child: Center(child: CircularProgressIndicator())),
          if (fileStatus == Status.done)
            const Expanded(child: Icon(Icons.done_outline)),
          const Text('Document'),
        ],
      ),
    );
  }
}
