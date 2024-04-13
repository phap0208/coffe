

import 'package:flutter/material.dart';

import 'model/PlaylistModel.dart';

class Playlist {
  final List<PlaylistModel> songs;

  Playlist({List<PlaylistModel>? initialSongs}) : songs = initialSongs ?? [];

  void addSong(PlaylistModel song) {
    songs.add(song);
  }

  void removeSong(PlaylistModel song) {
    songs.remove(song);
  }
}
class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist'),
      ),
      body: ListView.builder(
        itemCount: playlist.songs.length,
        itemBuilder: (context, index) {
          final song = playlist.songs[index];
          return ListTile(
            title: Text(song.songName ?? ''),
            leading: Image.network(song.thumbnailUrl ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                playlist.removeSong(song);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed song "${song.songName}" from playlist.'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}