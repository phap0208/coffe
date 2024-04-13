import 'dart:io';
void main() {
  Server().startServer('192.168.2.110', 12345); // Replace with your desired IP and port
}
class Server {
  late ServerSocket _serverSocket;
  void startServer(String address, int port) async {
    try {
      _serverSocket = await ServerSocket.bind(address, port);
      print('Server listening on $address:$port');
      _serverSocket.listen(
            (Socket clientSocket) {
          print('Client connected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
          clientSocket.listen(
                (List<int> data) {
              String receivedMessage = String.fromCharCodes(data).trim();
              print('Received message from client: $receivedMessage');
              // Here you can send a response back to the client if needed
            },
            onError: (error) {
              print('Error: $error');
            },
            onDone: () {
              print('Client disconnected');
            },
          );
        },
        onError: (error) {
          print('Error: $error');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}