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
                marker.width = MannaDemo.convertWidth(value: 50)
                marker.height = MannaDemo.convertWidth(value: 50)
                
                goalMarker.width = MannaDemo.convertWidth(value: 50)
                goalMarker.height = MannaDemo.convertWidth(value: 50)
                
                goalMarker.mapView = mapView
                marker.mapView = mapView
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cameraTrakingToggleFlag = false
        UIView.animate(withDuration: 0.5) { [self] in
            [myLocationButton, bottomTabView].forEach {
                $0.alpha = 1
                $0.isHidden = false
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        markerResizeByZoomLevel()
//        print(mapView.projection.latlngBounds(fromViewBounds: self.view.frame).hasPoint(goalMarker.position))
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        markerResizeByZoomLevel()
    }
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        markerResizeByZoomLevel()
    }
}
