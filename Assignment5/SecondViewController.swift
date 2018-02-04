//
//  SecondViewController.swift
//  Assignment5
//
//  Created by Hitesh Bhatia on 11/1/17.
//  Copyright © 2017 Hitesh Bhatia. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: FirstViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSearchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    @IBAction func mapSearchButton(_ sender: Any) {
         mapDataOnMap()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapDataOnMap(){
        let searchAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(searchAnnotations)
        
        let span : MKCoordinateSpan = MKCoordinateSpanMake(15, 15)
        
        for i in 0..<globalLat.count{
            var newCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
            var currentCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
            currentCoordinate = CLLocationCoordinate2D(latitude: globalLat[0], longitude: globalLon[0])
           
                newCoordinate = CLLocationCoordinate2D(latitude: globalLat[i], longitude: globalLon[i])
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(currentCoordinate, span)
            mapView.setRegion(region, animated: true)
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = newCoordinate
            newAnnotation.title = globalName[i]
            mapView.addAnnotation(newAnnotation)
        }
    }
}

