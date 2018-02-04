//
//  ForthViewController.swift
//  Assignment5
//
//  Created by Hitesh Bhatia on 11/5/17.
//  Copyright © 2017 Hitesh Bhatia. All rights reserved.
//

import UIKit
import MapKit

class ForthViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectLocationButton: UIButton!
    var mapLat : Double = 0.0
    var mapLon : Double = 0.0
    var thirdLat : String = ""
    var thirdLon : String = ""
    var country : String = ""
    var city : String = ""
    var state : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        //**Not really sure if this is required, but if required please uncomment the below method**
        //showFilteredUsersOnMap()
        
        if thirdLat != "0.0" && thirdLon != "0.0" {
            plotLocOnMap()
        }else if state != ""{
            showCurrentLoc()
        }else{
            showMap()
        }
    }
    
    func showFilteredUsersOnMap(){
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
    
    func showMap(){
        let span : MKCoordinateSpan = MKCoordinateSpanMake(45, 45)
        var currentCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
        currentCoordinate = CLLocationCoordinate2D(latitude: 40.270281, longitude: -96.836437)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentCoordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    
    func showCurrentLoc(){
        let searchReq = MKLocalSearchRequest()
        var searchLoc = state
        searchLoc.append(",")
        searchLoc.append(country)
        searchReq.naturalLanguageQuery = searchLoc
        
        let activeSearch = MKLocalSearch(request: searchReq)
        let span : MKCoordinateSpan = MKCoordinateSpanMake(3, 3)
        
        activeSearch.start{(response, error) in
            if response == nil {
                print("Error")
            }else{
                let searchAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(searchAnnotations)
                
                let currLat = response?.boundingRegion.center.latitude
                let currLon = response?.boundingRegion.center.longitude
                var currentCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
                currentCoordinate = CLLocationCoordinate2D(latitude: currLat!, longitude: currLon!)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(currentCoordinate, span)
                self.mapView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.title = "Current User"
                annotation.coordinate = CLLocationCoordinate2D(latitude: currLat!, longitude: currLon!)
                self.mapView.addAnnotation(annotation)
                self.mapLat = currLat!
                self.mapLon = currLon!
            }
        }
    }
    
    func plotLocOnMap(){
        let lat = thirdLat != "" ? Double(thirdLat) : 0.0
        let lon = thirdLon != "" ? Double(thirdLon) : 0.0
        var currentCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let span : MKCoordinateSpan = MKCoordinateSpanMake(1, 1)
        currentCoordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentCoordinate, span)
        mapView.setRegion(region, animated: true)
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = currentCoordinate
        mapView.addAnnotation(newAnnotation)
        mapLat = lat!
        mapLon = lon!
    }

    
    @IBAction func longPressEvent(_ sender: UILongPressGestureRecognizer) {
        let searchAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(searchAnnotations)
        let location = sender.location(in: self.mapView)
        let locCor = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        let ann = MKPointAnnotation()
        
        ann.coordinate = locCor
        mapLat = locCor.latitude
        mapLon = locCor.longitude
        ann.title = "Current User"
        
        self.mapView.addAnnotation(ann)
    }
    
    @IBAction func selectLocationButtonCLicked(_ sender: Any) {
        performSegue(withIdentifier: "returnIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        ThirdViewController.fourthLat = mapLat
        ThirdViewController.fourthLon = mapLon
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
