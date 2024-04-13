class PlaylistModel {
  PlaylistModel({
      this.dateTime,
      this.id,
      this.songName,
      this.songUrl,
      this.videoId,
      this.thumbnailUrl,
  });

  PlaylistModel.fromJson(dynamic json) {
    dateTime = json['dateTime'];
    id = json['id'];
    songName = json['songName'];
    songUrl = json['songUrl'];
    videoId = json['videoId'];
    thumbnailUrl = json['thumbnailUrl'];

  }
  String? dateTime;
  String? id;
  String? songName;
  String? songUrl;
  String? videoId;
  String? thumbnailUrl;

PlaylistModel copyWith({  String? dateTime,
  String? id,
  String? songName,
  String? songUrl,
  String? videoId,
  String? thumbnailUrl,
}) => PlaylistModel(  dateTime: dateTime ?? this.dateTime,
  id: id ?? this.id,
  videoId: videoId ?? this.videoId,
  songName: songName ?? this.songName,
  songUrl: songUrl ?? this.songUrl,
  thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,

);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dateTime'] = dateTime;
    map['_id'] = id;
    map['songName'] = songName;
    map['songUrl'] = songUrl;
    map['videoId'] = videoId;
    map['thumbnailUrl'] = thumbnailUrl;
    return map;
  }

}

class KaraokeSong {
  final String profileImageLink;
  final int facebookId;
  final String name;
  final String songName;
  final int viewCounter;
  final String videoId;
  final int id;
  final int bpm;
  final String key;
  final String songUrl;
  final String thumbnailUrl;
  KaraokeSong({
    required this.profileImageLink,
    required this.facebookId,
    required this.name,
    required this.songName,
    required this.viewCounter,
    required this.videoId,
    required this.id,
    required this.bpm,
    required this.key,
    required this.songUrl,
    required this.thumbnailUrl,
  });
  factory KaraokeSong.fromJson(Map<String, dynamic> json) {
    return KaraokeSong(
      profileImageLink: json["owner"]["profileImageLink"],
      facebookId: json["owner"]["facebookId"],
      name: json["owner"]["name"],
      songName: json["songName"],
      viewCounter: json["viewCounter"],
      videoId: json["videoId"],
      id: json["_id"],
      bpm: json["bpm"],
      key: json["key"],
      songUrl: json["songUrl"],
      thumbnailUrl: json["thumbnailUrl"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
    "owner": {
    "profileImageLink": profileImageLink,
    "facebookId": facebookId,
    "name": name,
    },
    "songName": songName,
    "viewCounter": viewCounter,
    "videoId": videoId,
    "_id": id,
    "bpm": bpm,
    "key": key,
    "songUrl": songUrl,
    "thumbnailUrl": thumbnailUrl,
    };
  }
}