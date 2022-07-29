import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map/state.dart';
import 'package:redux/redux.dart';

import 'type.dart';

final Reducer<MapState> mapReducer = combineReducers(
  [
    TypedReducer(_setMapStatus),
    TypedReducer(_addCommunityMarker),
    TypedReducer(_updateCommunityMarker),
    TypedReducer(_removeCommunityMarker),
    TypedReducer(_checkCommunityMarkersInPolygon),
    TypedReducer(_addDrawingPolygonPoint),
    TypedReducer(_setController),
    TypedReducer(_updateCameraPosition),
    TypedReducer(_moveCamera),
    TypedReducer(_clear),
    TypedReducer(_clearDrawingPolygon),
    TypedReducer(_updateWidgetSize),
  ],
);

MapState _setMapStatus(MapState state, SetMapStatus action) {
  return state.copyWith(
    mapStatus: action.mapStatus,
  );
}

MapState _addCommunityMarker(MapState state, AddMarker action) {
  if (state.id == action.mapId) {
    late final List<HouseMarker> markers;
    switch (action.markerType) {
      case MarkerType.community:
        markers = state.communityMarkers;
        break;
      case MarkerType.origin:
        markers = state.oriMarkers;
        break;
      case MarkerType.district:
        markers = state.districtMarkers;
        break;
    }
    markers.add(action.marker);
    switch (action.markerType) {
      case MarkerType.community:
        return state.copyWith(
          communityMarkers: markers,
        );
      case MarkerType.origin:
        return state.copyWith(
          oriMarkers: markers,
        );
      case MarkerType.district:
        return state.copyWith(
          districtMarkers: markers,
        );
    }
  } else {
    return state;
  }
}

MapState _updateCommunityMarker(MapState state, UpdateMarker action) {
  if (state.id == action.mapId) {
    late final Map<String, HouseMarker> markers;
    switch (action.markerType) {
      case MarkerType.community:
        markers = keyByHouseMarkerId(state.communityMarkers);
        break;
      case MarkerType.origin:
        markers = keyByHouseMarkerId(state.oriMarkers);
        break;
      case MarkerType.district:
        markers = keyByHouseMarkerId(state.districtMarkers);
        break;
    }

    markers[action.id] = markers[action.id]!.copyWithHouses(
      alphaParam: action.alphaParam,
      anchorParam: action.anchorParam,
      clickableParam: action.clickableParam,
      draggableParam: action.draggableParam,
      iconParam: action.iconParam,
      infoWindowEnableParam: action.infoWindowEnableParam,
      infoWindowParam: action.infoWindowParam,
      onDragEndParam: action.onDragEndParam,
      onTapParam: action.onTapParam,
      positionParam: action.positionParam,
      rotationParam: action.rotationParam,
      visibleParam: action.visibleParam,
      housesParam: action.housesParam,
    );
    switch (action.markerType) {
      case MarkerType.community:
        return state.copyWith(
          communityMarkers: markers.values.toList(),
        );
      case MarkerType.origin:
        return state.copyWith(
          oriMarkers: markers.values.toList(),
        );
      case MarkerType.district:
        return state.copyWith(
          districtMarkers: markers.values.toList(),
        );
    }
  } else {
    return state;
  }
}

MapState _removeCommunityMarker(MapState state, RemoveMarker action) {
  if (state.id == action.mapId) {
    late final Map<String, HouseMarker> markers;
    switch (action.markerType) {
      case MarkerType.community:
        markers = keyByHouseMarkerId(state.communityMarkers);
        break;
      case MarkerType.origin:
        markers = keyByHouseMarkerId(state.oriMarkers);
        break;
      case MarkerType.district:
        markers = keyByHouseMarkerId(state.districtMarkers);
        break;
    }
    markers.remove(action.createId);
    switch (action.markerType) {
      case MarkerType.community:
        return state.copyWith(
          communityMarkers: markers.values.toList(),
        );
      case MarkerType.origin:
        return state.copyWith(
          oriMarkers: markers.values.toList(),
        );
      case MarkerType.district:
        return state.copyWith(
          districtMarkers: markers.values.toList(),
        );
    }
  } else {
    return state;
  }
}

MapState _checkCommunityMarkersInPolygon(
    MapState state, CheckCommunityMarkersInPolygon action) {
  if (state.id == action.mapId) {
    final markers = state.communityMarkers;
    final markersInDrawingPolygon = <HouseMarker>[];
    final polygon = state.drawnPolygon;
    for (var marker in markers) {
      if (AMapTools.latLngIsInPolygon(marker.position, polygon)) {
        markersInDrawingPolygon.add(marker);
      }
    }

    return state.copyWith(
      markersInDrawingPolygon: markersInDrawingPolygon,
    );
  } else {
    return state;
  }
}

MapState _addDrawingPolygonPoint(MapState state, AddDrawnPolygonPoint action) {
  if (state.id == action.mapId) {
    final position = action.position;
    final drawingPolygon = state.drawnPolygon;

    drawingPolygon.add(position);

    return state.copyWith(
      drawnPolygon: drawingPolygon,
    );
  } else {
    return state;
  }
}

MapState _clearDrawingPolygon(MapState state, ClearDrawingPolygon action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawnPolygon: [],
    );
  } else {
    return state;
  }
}

MapState _setController(MapState state, SetController action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      controller: action.controller,
    );
  } else {
    return state;
  }
}

MapState _updateCameraPosition(MapState state, UpdateCameraPosition action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      cameraPosition: action.cameraPosition,
    );
  } else {
    return state;
  }
}

MapState _moveCamera(MapState state, MoveCamera action) {
  if (state.id == action.mapId) {
    state.controller?.moveCamera(
      CameraUpdate.newCameraPosition(
        action.cameraPosition,
      ),
    );
    return state.copyWith(cameraPosition: action.cameraPosition);
  }
  return state;
}

MapState _clear(MapState state, Clear action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      drawnPolygon: [],
      communityMarkers: [],
      reachingPolygon: [],
    );
  } else {
    return state;
  }
}

MapState _updateWidgetSize(MapState state, UpdateWidgetSize action) {
  if (state.id == action.mapId) {
    return state.copyWith(
      widgetSize: action.widgetSize,
    );
  } else {
    return state;
  }
}
