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
    var destinationLocation: CLLocationCoordinate2D?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15
    var sideMenu: SideMenu!
    var markers = [GMSMarker]()
    var polyline: GMSPolyline!
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generalize those later
        navigationItem.title = "Locate a power station"
        
        view.addSubview(loadingView)
        UIView.animate(withDuration: 0.5, animations: {
            loadingView.alpha = 1
            refreshIndicator.startAnimating()
        })
        
        inititateLocationManager()
        
        self.currentLocation = locationManager.location
        
        if let currentLocation = locationManager.location?.coordinate{
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: zoomLevel)
            mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
            mapView.settings.myLocationButton = true
            mapView.delegate = self
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.selectedMarker = createMapMarker(markerTitle: YOUR_CURRENT_POS, latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            mapView.isHidden = true
            view.addSubview(mapView)
            view.addSubview(loadingView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // initiating side menu
        sideMenu = SideMenu(controllingViewController: self)
        if let userData = user{
            sideMenu.nameLabel.text = userData.username
            sideMenu.mailLabel.text = userData.username + "@test.com"
            sideMenu.totalCreditLabel.text = "You have $\(userData.totalCredit) left."
        }
        fetchData()
    }
    
    //MARK: Handle Side Menu Options
    
    func handleSideMenuOptions(selection: Int) {
        if selection == 0{
            fetchData()
        } else {
            performSegue(withIdentifier: LOG_IN_VC_SEGUE, sender: self)
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
                        //print(results)
                        for result in results{
                            if let result = result as? NSDictionary{
                                guard let location = result.value(forKey: LOCATION) as? NSArray else { return }
                                guard let stationName = result.value(forKey: STATION_NAME) as? String else {  return }
                                
                                // location[1] is latitude
                                // location[0] is longitude
                                // name is for the station name
                                
                                self.markers.append(self.createMapMarker(markerTitle: stationName, latitude: location[1] as! CLLocationDegrees, longitude: location[0] as! CLLocationDegrees))
                            }
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    // adding markers on the map
                    let markerIconView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
                    markerIconView.layer.cornerRadius = 10
                    markerIconView.backgroundColor = UIColor.clear
                    let imageView = UIImageView(frame: markerIconView.frame)
                    imageView.image = UIImage(named: "PowerStationIcon")
                    markerIconView.addSubview(imageView)
                    markerIconView.tintColor = UIColor.red
                    
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

