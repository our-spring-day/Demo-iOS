//
//  MapView+NaverMap.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/06.
//

import Foundation
import NMapsMap

extension MapViewController: NMFMapViewCameraDelegate {
    func zoomLinearEquation(zoomLevel: Double) -> CGFloat{
        return  CGFloat(-5 * zoomLevel + 115)
    }
    
    func markerResizeByZoomLevel() {
        if mapView.zoomLevel > 13 {
            tokenWithMarker.map { (key, marker) in
                marker.width = MannaDemo.convertWidth(value: zoomLinearEquation(zoomLevel: mapView.zoomLevel))
                marker.height = MannaDemo.convertWidth(value: zoomLinearEquation(zoomLevel: mapView.zoomLevel))
                
                goalMarker.width = MannaDemo.convertWidth(value: zoomLinearEquation(zoomLevel: mapView.zoomLevel))
                goalMarker.height = MannaDemo.convertWidth(value: zoomLinearEquation(zoomLevel: mapView.zoomLevel))
                
                marker.mapView = mapView
                goalMarker.mapView = mapView
            }
        } else {
            tokenWithMarker.map { (key, marker) in
                marker.width = 56
                marker.height = 56
                
                goalMarker.width = 48
                goalMarker.height = 48
                
                goalMarker.mapView = mapView
                marker.mapView = mapView
            }
        }
    }
    
    func myMarkerOnOverlay() {
        let test = mapView.projection.point(from: NMGLatLng(lat: mapView.locationOverlay.location.lat, lng: mapView.locationOverlay.location.lng))
        var newLat = test.y - MannaDemo.convertWidth(value: 8)
        let realLatLng = mapView.projection.latlng(from: CGPoint(x: test.x, y: newLat))
        tokenWithMarker[MannaDemo.myUUID!]?.position = NMGLatLng(lat: realLatLng.lat, lng: realLatLng.lng)
        tokenWithMarker[MannaDemo.myUUID!]?.mapView = mapView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let test = mapView.projection.point(from: NMGLatLng(lat: mapView.locationOverlay.location.lat, lng: mapView.locationOverlay.location.lng))
        var newLat = test.y - MannaDemo.convertWidth(value: 8)
        let realLatLng = mapView.projection.latlng(from: CGPoint(x: test.x, y: newLat))
        currentTimer.invalidate()
        tokenWithMarker[MannaDemo.myUUID!]?.position = NMGLatLng(lat: realLatLng.lat, lng: realLatLng.lng)
        tokenWithMarker[MannaDemo.myUUID!]?.alpha = 1
        tokenWithMarker[MannaDemo.myUUID!]?.mapView = mapView
        
        myLocationButton.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
        mapView.positionMode = .normal
        mapView.locationOverlay.icon = defaultOverlayImageOverlay
        
        UIView.animate(withDuration: 0.5) { [self] in
            [myLocationButton].forEach {
                $0.setImage(#imageLiteral(resourceName: "mylocation"), for: .normal)
                $0.alpha = 1
                $0.isHidden = false
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        markerResizeByZoomLevel()
        myMarkerOnOverlay()
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        markerResizeByZoomLevel()
        myMarkerOnOverlay()
    }
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        markerResizeByZoomLevel()
        myMarkerOnOverlay()
    }
}
