import 'package:flutter/material.dart';
import 'remote/remote_event.dart';
import 'remote/remote_state.dart';

import 'remote/remote_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bloc = RemoteBloc(); // khởi tạo bloc  <=== new

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StreamBuilder<RemoteState>(
            // sử dụng StreamBuilder để lắng nghe Stream <=== new
            stream: bloc.stateController
                .stream, // truyền stream của stateController vào để lắng nghe <=== new
            initialData: bloc
                .state, // giá trị khởi tạo chính là volume 70 hiện tại <=== new
            builder:
                (BuildContext context, AsyncSnapshot<RemoteState> snapshot) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Âm lượng hiện tại: ${snapshot.data!.volume}'),
                  Text('Kênh hiện tại: ${snapshot.data!.channel}'),
                ],
              ); // update UI <=== new
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () => bloc.eventController.sink
                      .add(PreviousChannelEvent(1)), // add event <=== new
                  child: const Icon(Icons.exposure_minus_1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () => bloc.eventController.sink
                      .add(NextChannelEvent(1)), // add event <=== new
                  child: const Icon(Icons.plus_one),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () => bloc.eventController.sink
                      .add(MuteEvent()), // add event <=== new
                  child: const Icon(Icons.volume_mute),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () => bloc.eventController.sink
                      .add(DecrementEvent(10)), // add event <=== new
                  child: const Icon(Icons.volume_down),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () => bloc.eventController.sink
                      .add(IncrementEvent(5)), // add event <=== new
                  child: const Icon(Icons.volume_up),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose(); // dispose bloc <=== new
  }
}
