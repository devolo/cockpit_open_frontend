import 'dart:io';  //only for non-web apps!!!
import 'dart:async';

Socket socket;

void main() {
  Socket.connect("localhost", 24271).then((Socket sock) {
    socket = sock;
    socket.listen(dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false);
  }).catchError((AsyncError e) {
    print("Unable to connect: $e");
  });
  //Connect standard in to the socket
  stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
}

void dataHandler(data){
  //print(new String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace){
  print(error);
}

void doneHandler(){
  print('destroying socket...');
  socket.destroy();
}