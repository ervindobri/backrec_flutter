import 'package:backrec_flutter/models/marker.dart';
import 'package:video_player/video_player.dart';

class RecordService {
  List<Marker> markers = [];
  late VideoPlayerController thumbnailController;

  setMarkers(List<Marker> markers) {
    this.markers = markers;
  }
}
