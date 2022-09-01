import 'dart:async';

import 'remote_event.dart';
import 'remote_state.dart';

class RemoteBloc {
  var state = RemoteState(
    volume: 70,
    channel: 2,
  ); // init giá trị khởi tạo của RemoteState. Giả sử TV ban đầu có âm lượng 70

  // tạo 2 controller
  // 1 cái quản lý event, đảm nhận nhiệm vụ nhận event từ UI
  final eventController = StreamController<RemoteEvent>();

  // 1 cái quản lý state, đảm nhận nhiệm vụ truyền state đến UI
  final stateController = StreamController<RemoteState>();

  RemoteBloc() {
    // lắng nghe khi eventController push event mới
    eventController.stream.listen((RemoteEvent event) {
      // người ta thường tách hàm này ra 1 hàm riêng và đặt tên là: mapEventToState
      // đúng như cái tên, hàm này nhận event xử lý và cho ra output là state

      if (event is IncrementEvent) {
        // nếu eventController vừa add vào 1 IncrementEvent thì chúng ta xử lý tăng âm lượng
        state = RemoteState(
          volume: state.volume + event.increment,
          channel: state.channel,
        );
      } else if (event is DecrementEvent) {
        // xử lý giảm âm lượng
        state = RemoteState(
          volume: state.volume - event.decrement,
          channel: state.channel,
        );
      } else if (event is NextChannelEvent) {
        state = state = RemoteState(
          volume: state.volume,
          channel: state.channel + event.next,
        );
      } else if (event is PreviousChannelEvent) {
        state = state = RemoteState(
          volume: state.volume,
          channel: state.channel - event.previous,
        );
      } else {
        // xử lý mute
        state = RemoteState(volume: 0, channel: state.channel);
      }

      // add state mới vào stateController để bên UI nhận được
      stateController.sink.add(state);
    });
  }

  // khi không cần thiết thì close tất cả controller
  void dispose() {
    stateController.close();
    eventController.close();
  }
}
