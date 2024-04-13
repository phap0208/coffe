import 'package:flutter/cupertino.dart';

class Video {
  final String name;
  final String url;
  final String title;
  final String thumbnailUrl;

  const Video({
    required this.name,
    required this.url,
    required this.title,
    required this.thumbnailUrl,
  });
}

const videos = [
  Video(
    name: 'Áo Mới Cà Mau',
    url: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/mp3/TGSFpC58V0Q.mp3',
    title: 'Hoài Lâm',
    thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
  Video(
    name: 'karaoke',
    url: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/mp3/nNT_qCREu3k.mp3',
    title: 'tác gia',
      thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
  Video(
    name: 'A1',
    url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    title: 'hehehe',
      thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
    Video(
    name: 'A2',
    url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    title: 'hhuhu',
        thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
  Video(
    name: 'A3',
    url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    title: 'hahah',
      thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
  Video(
    name: 'A4',
    url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    title: 'hahah',
      thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
  Video(
    name: 'A5',
    url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
    title: 'hahah',
      thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
  Video(
    name: 'A6',
    url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    title: 'hahah',
      thumbnailUrl: 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg'
  ),
];