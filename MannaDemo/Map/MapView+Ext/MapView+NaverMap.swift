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
        return  CGFloat(-(25/3) * zoomLevel + 175)
    }
    
    func markerResizeByZoomLevel() {
        if mapView.zoomLevel > 15 {
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
        myLocationButton.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.myLocationButton.alpha = 1
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        print("will")
        markerResizeByZoomLevel()
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        print("end")
        markerResizeByZoomLevel()
    }
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        print("change")
        markerResizeByZoomLevel()
    }
}
