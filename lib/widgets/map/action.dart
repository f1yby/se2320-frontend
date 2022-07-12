import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/service/backend_service/house/rent_house.dart';
import 'package:app/widgets/map/type.dart';

class MapAction {
  final String mapId;

  MapAction({
    required this.mapId,
  });
}

class AddMarker extends MapAction {
  final HouseMarker marker;

  AddMarker({
    required super.mapId,
    required this.marker,
  });
}
class AddOriMarker extends MapAction {
  final HouseMarker marker;

  AddOriMarker({
    required super.mapId,
    required this.marker,
  });
}
class UpdateOriMarker extends MapAction {
  final String id;
  final double? alphaParam;
  final Offset? anchorParam;
  final bool? clickableParam;
  final bool? draggableParam;
  final BitmapDescriptor? iconParam;
  final bool? infoWindowEnableParam;
  final InfoWindow? infoWindowParam;
  final LatLng? positionParam;
  final double? rotationParam;
  final bool? visibleParam;
    final List<RentHouse>? housesParam;
  final ArgumentCallback<String?>? onTapParam;
  final MarkerDragEndCallback? onDragEndParam;

  UpdateOriMarker({
    this.alphaParam,
    this.anchorParam,
    this.clickableParam,
    this.draggableParam,
    this.iconParam,
    this.infoWindowEnableParam,
    this.infoWindowParam,
    this.positionParam,
    this.rotationParam,
    this.visibleParam,
    this.onTapParam,
    this.onDragEndParam,
    this.housesParam,
    required super.mapId,
    required this.id,
  });
}

class RemoveOriMarker extends MapAction {
  final String createId;

  RemoveOriMarker({
    required this.createId,
    required super.mapId,
  });
}

class UpdateMarker extends MapAction {
  final String id;
  final double? alphaParam;
  final Offset? anchorParam;
  final bool? clickableParam;
  final bool? draggableParam;
  final BitmapDescriptor? iconParam;
  final bool? infoWindowEnableParam;
  final InfoWindow? infoWindowParam;
  final LatLng? positionParam;
  final double? rotationParam;
  final bool? visibleParam;
  final ArgumentCallback<String?>? onTapParam;
  final MarkerDragEndCallback? onDragEndParam;
  final List<RentHouse>? housesParam;

  UpdateMarker({
    this.alphaParam,
    this.anchorParam,
    this.clickableParam,
    this.draggableParam,
    this.iconParam,
    this.infoWindowEnableParam,
    this.infoWindowParam,
    this.positionParam,
    this.rotationParam,
    this.visibleParam,
    this.onTapParam,
    this.onDragEndParam,
    this.housesParam,
    required super.mapId,
    required this.id,
  });
}



class RemoveMarker extends MapAction {
  final String createId;

  RemoveMarker({
    required this.createId,
    required super.mapId,
  });
}

class CheckPointsInPolygon extends MapAction {
  CheckPointsInPolygon({
    required super.mapId,
  });
}

class StartDrawPolygon extends MapAction {
  StartDrawPolygon({
    required super.mapId,
  });
}

class AddPolygonPoint extends MapAction {
  final LatLng position;

  AddPolygonPoint({
    required super.mapId,
    required this.position,
  });
}

class EndDrawPolygon extends MapAction {
  EndDrawPolygon({
    required super.mapId,
  });
}

class ClearPolygon extends MapAction {
  ClearPolygon({
    required super.mapId,
  });
}

class SetController extends MapAction {
  final AMapController controller;

  SetController({
    required super.mapId,
    required this.controller,
  });
}

class UpdateCameraPosition extends MapAction {
  final CameraPosition cameraPosition;

  UpdateCameraPosition({
    required super.mapId,
    required this.cameraPosition,
  });
}

class MoveCamera extends MapAction {
  final CameraPosition cameraPosition;

  MoveCamera({
    required super.mapId,
    required this.cameraPosition,
  });
}

class Clear extends MapAction {
  Clear({
    required super.mapId,
  });
}

class UpdateWidgetSize extends MapAction {
  final Size widgetSize;

  UpdateWidgetSize({
    required this.widgetSize,
    required super.mapId,
  });
}
