//
//  MainMenuExt.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

extension MainMenuVC: CLLocationManagerDelegate, GMSMapViewDelegate, CustomAlertControllerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        // update current location
        currentLocation = location
        
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            UIView.animate(withDuration: 0.5, animations: {
                loadingView.alpha = 0
                refreshIndicator.stopAnimating()
                self.mapView.isHidden = false
            })
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    internal func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        if let myCurrentLocation = currentLocation?.coordinate{
            let camera = GMSCameraPosition.camera(withLatitude: myCurrentLocation.latitude, longitude: myCurrentLocation.longitude, zoom: zoomLevel)
            if mapView.isHidden {
                UIView.animate(withDuration: 0.5, animations: {
                    loadingView.alpha = 0
                    refreshIndicator.stopAnimating()
                    self.mapView.isHidden = false
                })
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
        }
        return true
    }
    
    internal func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.position)
        
        if let myLocation = currentLocation?.coordinate{
            if marker.position.latitude != myLocation.latitude && marker.position.longitude != myLocation.longitude{
                destinationLocation = marker.position
                alert = CustomAlertController(message: "Hey", description: "Do you want to go to \(marker.title!)", dismissButtonName: "No", demandButtonName: "Yes", shouldVibrate: false, optionsHandlingViewController: self)
                alert.show()
            } else {
                alert = CustomAlertController(message: "Come on 🤪", description: "You cannot go to your location", buttonTitle: "OK", shouldVibrate: false)
                alert.show()
            }
        }
        return true
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    // initiate location manager
    func inititateLocationManager(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 0.5
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    // create a map marker
    func createMapMarker(markerTitle: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> GMSMarker{
        let marker = GMSMarker()
        marker.title = markerTitle
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = self.mapView
        return marker
    }
    
    func handleAlertOptionsForButtons(option: Int) {
        if option == 1{
            guard let destLocation = destinationLocation else { return }
            guard let sourceLocation = currentLocation?.coordinate else { return }
            
            //clearing the path if there is any
            if polyline != nil {
                polyline.map = nil
            }
            
            getPolylineRoute(from: sourceLocation, to: destLocation)
        }
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        UIView.animate(withDuration: 0.5) {
            loadingView.alpha = 1
            refreshIndicator.startAnimating()
        }
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=walking")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let preRoutes = json["routes"] as! NSArray
                        let routes = preRoutes[0] as! NSDictionary
                        let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                        let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                        
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.5, animations: {
                                loadingView.alpha = 0
                                refreshIndicator.startAnimating()
                            })
                            
                            let path = GMSPath(fromEncodedPath: polyString)
                            self.polyline = GMSPolyline(path: path)
                            self.polyline.strokeWidth = 4.0
                            self.polyline.strokeColor = UIColor.blue
                            self.polyline.map = self.mapView
                        }
                    }
                    
                }catch{
                    print("Couldn't serialize Json!")
                }
            }
        })
        task.resume()
    }
}

