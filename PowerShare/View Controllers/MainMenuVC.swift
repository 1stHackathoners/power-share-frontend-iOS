//
//  MainMenuVC.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class MainMenuVC: UIViewController, SideMenuDelegate {
    
    //MARK: Properties
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15
    var sideMenu: SideMenu!
    var markers = [GMSMarker]()
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generalize those later
        navigationItem.title = "Locate a power station"
        
        inititateLocationManager()
        
        sideMenu = SideMenu(controllingViewController: self)
        self.currentLocation = locationManager.location
        
        if let currentLocation = locationManager.location?.coordinate{
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: zoomLevel)
            mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
            mapView.settings.myLocationButton = true
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.selectedMarker = createMapMarker(markerTitle: YOUR_CURRENT_POS, latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            mapView.isHidden = true
            view.addSubview(mapView)
        }
        
        fetchData()
    }
    
    //MARK: Handle Side Menu Options
    
    func handleSideMenuOptions(selection: Int) {
        if selection == 0{
            fetchData()
            
        } else {
            //logout and go to the login screen 
        }
    }
    
    //MARK: Actions
    
    @IBAction func showMenuBarButtonItemPressed(_ sender: UIBarButtonItem) {
        sideMenu.showMenu()
    }
    
    
    //MARK: Fetching Data Operations
    private func fetchData(){
        for marker in markers {
            marker.map = nil
        }
        self.markers.removeAll()
        
        let url = URL(string: "https://power-share-hackathon.herokuapp.com/find/powerbank")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let location = currentLocation?.coordinate else { return } 
        
        let postString = "latitude=\(location.latitude)&longitude=\(location.longitude)&range=\(sideMenu.radius * 1000)"
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    //showing an alert if something goes wrong
                    let alert = UIAlertController(title: "Upsss!", message: "The load has been added to the completion queue. This will be processed once there is a connection.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                if let json = json {
                    //print(json)
                    if let results = json.value(forKey: RESULT) as? NSArray{
                        
                        for result in results{
                            if let result = result as? NSDictionary{
                                guard let location = result.value(forKey: LOCATION) as? NSArray else { return }
                                guard let stationName = result.value(forKey: NAME) as? String else { return }
                                
                                // location[1] is latitude
                                // location[2] is longitude
                                // name is for the station name
                                
                                self.markers.append(self.createMapMarker(markerTitle: stationName, latitude: location[1] as! CLLocationDegrees, longitude: location[0] as! CLLocationDegrees))
                            }
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    // adding markers on the map
                    
                    let markerIconView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                    markerIconView.layer.cornerRadius = 10
                    markerIconView.backgroundColor = UIColor.green
                    markerIconView.layer.borderWidth = 1
                    markerIconView.layer.borderColor = UIColor.blue.cgColor
                    
                    for marker in self.markers{
                        marker.map = self.mapView
                        marker.iconView = markerIconView
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

