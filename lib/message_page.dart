// import 'package:flutter/foundation.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class Message extends StatelessWidget {
//   static String tag = 'message-page';
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MessageStateful(
//         channel: IOWebSocketChannel.connect('ws://demos.kaazing.com/echo'),
//         //channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),
//       ),
//     );
//   }
// }

// class MessageStateful extends StatefulWidget {
//   final WebSocketChannel channel;

//   MessageStateful({Key key, this.channel}) : super(key: key);

//   @override
//   _MessageStatefulState createState() => _MessageStatefulState();
// }

// class _MessageStatefulState extends State<MessageStateful> {
//   TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: InputDecoration(labelText: 'Send a message'),
//               ),
//             ),
//             StreamBuilder(
//               stream: widget.channel.stream,
//               builder: (context, snapshot) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 24.0),
//                   child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
      
//       floatingActionButton: FloatingActionButton(
//         tooltip: 'Send message',
//         child: Icon(Icons.send),
//         onPressed: (){
//           print(_controller.text);
//           _sendMessage();},
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       widget.channel.sink.add(_controller.text);
//     }
//   }

//   @override
//   void dispose() {
//     widget.channel.sink.close();
//     super.dispose();
//   }
// }
