//
//  MapViewController.swift
//  MannaDemo
//
//  Created by once on 2020/10/21.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }
}
