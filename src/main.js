import './style.css'
import maplibregl from 'maplibre-gl'
import '../node_modules/maplibre-gl/dist/maplibre-gl.css'
import style from '../style-satellite.json'
import { Protocol } from "pmtiles";

let protocol = new Protocol();
maplibregl.addProtocol("pmtiles",protocol.tile);

const mapOpts = {
  container: 'map',
  style: style,
  attributionControl: false,
  center: [-8.23, 39.65],
  minZoom: 6,
  pitch: 0,
  bearing: 0,
  maxPitch: 75,
  hash: true
}

const map = new maplibregl.Map(mapOpts)

map.addControl(
  new maplibregl.NavigationControl({
      visualizePitch: true,
      showZoom: true,
      showCompass: true
  })
);

map.addControl(
  new maplibregl.ScaleControl({
    maxWidth: 80,
    unit: 'metric'
  }),
  'bottom-left'
);

map.addControl(
  new maplibregl.GeolocateControl({
		positionOptions: {
      enableHighAccuracy: true
    },
		trackUserLocation: true
  }),
  'top-right'
);

map.addControl(
  new maplibregl.AttributionControl({
    compact: true
  })
);