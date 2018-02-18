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

class MainMenuVC: UIViewController, SideMenuDelegate {
    
    //MARK: Properties
    var locationManager: CLLocationManager!
    var mapView: GMSMapView!
    var polyline: GMSPolyline!
    var zoomLevel: Float = 15
    
    var markers = [GMSMarker]()
    var stations = [Stations]()
    var currentStationName: String!
    var currentMarker: GMSMarker!
    
    var currentLocation: CLLocation?
    var destinationLocation: CLLocation?
    var temporaryDestinationLocation: CLLocation?

    var sideMenu: SideMenu!
    
    var chooseAlertHandler = false
    var alerted = false
    
    var startTime: Date!
    var endTime: Date!
    var timeStart = true
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        navigationItem.title = "Locate a power station"
        view.addSubview(loadingView)
        
        UIView.animate(withDuration: 0.5, animations: {
            loadingView.alpha = 1
            refreshIndicator.startAnimating()
        })
        
        inititateLocationManager()
        currentLocation = locationManager.location
        
        if let currentLocation = locationManager.location?.coordinate{
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: zoomLevel)
            
            mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
            mapView.settings.myLocationButton = true
            mapView.delegate = self
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            currentMarker = createMapMarker(markerTitle: YOUR_CURRENT_POS, snippet: nil, latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.tintColor = UIColor.blue
            imageView.image = UIImage(named: "RunningGuyIcon")
            
            currentMarker.iconView = imageView
            
            mapView.selectedMarker = currentMarker
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
                                // location[1] is latitude
                                // location[0] is longitude
                                
                                guard let location = result.value(forKey: LOCATION) as? NSArray else { return }
                                guard let stationName = result.value(forKey: STATION_NAME) as? String else { return }
                                guard let availableChargePortNum = result.value(forKey: "available_cp_num") as? Int else { return }
                                guard let availablePowerBankNum = result.value(forKey: "available_pb_num") as? Int else { return }
                                
                                let _location = CLLocation(latitude: location[1] as! CLLocationDegrees, longitude: location[0] as! CLLocationDegrees)
                                
                                let station = Stations(name: stationName, location: _location , availablePowerBankNum: availablePowerBankNum, availableChargePortNum: availableChargePortNum, marker: self.createMapMarker(markerTitle: stationName, snippet: nil, latitude: location[1] as! CLLocationDegrees, longitude: location[0] as! CLLocationDegrees))
                                
                                self.stations.append(station)
                            }
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    // adding markers on the map
                    let markerIconView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
                    markerIconView.backgroundColor = UIColor.clear
                    let imageView = UIImageView(frame: markerIconView.frame)
                    imageView.image = UIImage(named: "PowerStationIcon")
                    markerIconView.addSubview(imageView)
                    markerIconView.tintColor = UIColor.red
                    
                    for station in self.stations{
                        station.marker.map = self.mapView
                        station.marker.iconView = markerIconView
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func session(username: String, changedTo: String, psName: String){
        print("Sending session")
        print(username)
        print(psName)
        
        let url = URL(string: "https://power-share-hackathon.herokuapp.com/user/sessionChange")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let postString = "username=\(username)&changedTo=\(changedTo)&psName=\(psName)"
        
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
                    print(json)
                    
                    if let succesCode = json.value(forKey: "code") as? Int, let message = json.value(forKey: "msg") as? String{
                        let alert = UIAlertController(title: "Session", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                        if succesCode == 1 {
                            
                            print(message)
                            if let fee = json.value(forKey: "fee") as? Double, let user = user{
                                user.totalCredit = user.totalCredit - fee
                                self.sideMenu.totalCreditLabel.text = String(format: "You have $ %.2f left", user.totalCredit)
                            }
                        } else {
                            print(message)
                        }
                    }
                    
                    
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

