//
//  ViewController.swift
//  MapVision
//
//  Created by 陳 冠禎 on 2016/11/2.
//  Copyright © 2016年 陳 冠禎. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    
    //data for show on the map
    //var restaurant = Rastaurants() //for instance and link restaurant data arrays
    
    
    
    // get the array of every single restaurant
//    var restaurants = v1API()
//    var restaurant:Rastaurants.restaurant?
    var API = v1API()
    var restaurants:[restaurant?] = []
    
    //mapview
    var selectedPin: MKPlacemark?
    var selectedPinName:String?
    @IBOutlet var mapView: MKMapView!
    
    //location
    var myLocationManager: CLLocationManager!
    var location = CLLocationCoordinate2D() //current location for annotation
    var currentLocation:locate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("view did load")
        mapViewInfoCustomize()
        initializeLocationManager()
        authrizationStatus()
        
        print("currentLocation: \(self.currentLocation)")
        
        //25.0037154
        //121.5145271
        // GET /v1/reataurant
        API.getNearbyRestaurantList(Latitude:Float(self.location.latitude), Longitude: Float(self.location.longitude), callback: {(resList)->Void in
            for res in resList!
            {
                self.restaurants.append(res)
            }
            self.handleAnnotationInfo()
        })
        
        
        
        // API
        // GET /v1/search
//        print("API.getNearbyRestaurant")
//        API.getNearbyRestaurant(Latitude: 25.0037154,
//                                Longitude: 121.5145271,
//                                callback:
//            {(res,foo)->Void in
//                print("****************")
//                print("res: \(res)")
//                print("****************")
//                self.restaurants.append(res)
//                self.restaurants.append(res)
//                self.handleAnnotationInfo()
//                print("self.restaurant: \(self.restaurants)")
////                print("res, name:\(res?.name), local:(\(res?.location?.longitude),\(res?.location?.latitude)), placeid:\(res?.place_id), vicinty:\(res?.vicinity) \n");
//                //
//                //
//                //                print("food, id:\(foo?.id), name:\(foo?.name), placeid:\(foo?.place_id), price:\(foo?.price), url:\(foo?.url) \n");
//        });
        
        // GET /v1/search/action
//        print("API.furtherAction")
//        API.furtherAction(Latitude: 25.023696,
//                          Longitude: 121.5252311,
//                          place_id: "ChIJN5RMH5CpQjQRAoN8D1LuNeM",
//                          food_id: "f000003",
//                          action: enjoy_status_action.dislike,
//                          callback:
//            {(res,foo)->Void in
//                print("res, name:\(res?.name), local:(\(res?.location?.longitude),\(res?.location?.latitude)), placeid:\(res?.place_id), vicinty:\(res?.vicinity) \n");
//                
//                
//                print("food, id:\(foo?.id), name:\(foo?.name), placeid:\(foo?.place_id), price:\(foo?.price), url:\(foo?.url) \n");
//        });
        
        
        //
//    let downloadData = restaurants.downloadData
       
        
//    downloadData(){
//        print()
        
//                }
    }
    
    
    func mapViewInfoCustomize(){
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = true
    }
    
    func getDirections(){
        //open apple map app and show the routing and name which is user's seleted
        guard let selectedPin = self.selectedPin else {return}
        let mapItem = MKMapItem(placemark: selectedPin)
        mapItem.name = self.selectedPinName
        print("Your mapItem.name : \(mapItem.name)")
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
        
    }
    
    
    func handleAnnotationInfo() {
        
        let restaurants = self.restaurants
        
        var location = CLLocationCoordinate2D()
        location = self.location
        print("currentLocation  \(location)")
        
        let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
       
        print("\(restaurants)")
        //set Annotation with parser imformation
        for index in 0...(restaurants.count - 1){
            
            let objectAnnotation = CustomPointAnnotation()
            
            //get coordinate and distance for display on the map
//            let latitude:CLLocationDegrees = Double(restaurants[index].latitude)
//            let longitude:CLLocationDegrees = Double(restaurants[index].longitude)
            let latitude:CLLocationDegrees = Double((restaurants[index]?.location?.latitude)!)
            let longitude:CLLocationDegrees = Double((restaurants[index]?.location?.longitude)!)
                //get restaurant location of coordinat
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            objectAnnotation.coordinate = coordinate
            
            
                //get distance from currentLocation to destinate
            let destinationOfCoordinats = CLLocation(latitude: latitude, longitude: longitude)
            let distanceInMeter = destinationOfCoordinats.distance(from: currentLocation) / 1000
            
            let distanceInKm = String(format:"%.1f", distanceInMeter)
            print("km \(distanceInKm)")
            objectAnnotation.distance = distanceInKm
            
            //get name for title of apple map navigation
            if let name = restaurants[index]?.name {
                let placemark = MKPlacemark(coordinate: coordinate, addressDictionary:[name: ""])
               
                objectAnnotation.placemark = placemark
            }
            
            
            
            //customize picture of pin
//           let pinImage = self.restaurants.typeOfFoodsImage(restaurnt: restaurants, index: index)
            
            objectAnnotation.imageName = UIImage(named: "rice")
            
            if let name = restaurants[index]?.name {
                objectAnnotation.title = name
            }
                //print("\(objectAnnotation.title!), name:\(name)")
            self.mapView?.addAnnotation(objectAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil}
        
        let identifier = "restaurant"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView != nil {
            annotationView?.annotation = annotation
            
        }else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let customAnnotation = annotation as! CustomPointAnnotation
            let distance = Double(customAnnotation.distance!)!
            var width = 25
            if (distance > 100) {
                width = 40
            }
            else{
                width = 25
            }
            
            
            let textSquare = CGSize(width:width , height: 40)
            let subTitleView:UILabel! = UILabel(frame: CGRect(origin: CGPoint.zero, size: textSquare))
            subTitleView.font = subTitleView.font.withSize(12)
            subTitleView.textAlignment = NSTextAlignment.right
            subTitleView.numberOfLines = 0
            subTitleView.textColor = UIColor.gray
            subTitleView.text = "\(customAnnotation.distance!) km"
            
            
            
            annotationView?.image =  customAnnotation.imageName
            
            let smallSquare = CGSize(width: 43, height: 43)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "go"), for: UIControlState())
            button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = button
            annotationView?.leftCalloutAccessoryView = subTitleView
            
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        
        if let annotation = view.annotation as? CustomPointAnnotation {
            self.selectedPin = annotation.placemark
            if let name = annotation.title {
                self.selectedPinName = "\(name)餐廳"
                print("Your annotationView title: \(name)")
            }
            
        }
        
        func mapView(_ mapView:MKMapView , regionWillChangeAnimated: Bool){
            print("region will change")
        }
    }

    
    //// compass
    //    var mapUserTrackingMod:Bool = false
    //
    //    @IBAction func locationArrowPressed(_ sender: AnyObject) {
    //        if mapUserTrackingMod {
    //
    //
    //            setCurrentLocation(latDelta: 0.05, longDelta: 0.05)
    //
    //            self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: false)
    //            locationArrowImage.setImage(UIImage(named: "locationArrow"), for: UIControlState.normal)
    //            mapUserTrackingMod = false
    //            print("follow")
    //
    //        }else{
    //
    //            setCurrentLocation(latDelta: 0.01, longDelta: 0.01)
    //            self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
    //            locationArrowImage.setImage(UIImage(named: "locationArrorFollewWithHeading"), for: UIControlState.normal)
    //            mapUserTrackingMod = true
    //            print("followWithHeading")
    //        }
    //
    //    }
    //
    
//    func typeOfFoodsImage(restaurnts:restaurants, index:Int) -> String {
//        var pinImage = ""
//        
//        if let type = restaurnts[index].type {
//            switch type {
//                
//            case rice: pinImage = "rice"
//                
//            case noddle: pinImage = "noddle"
//                
//            case japansFood: pinImage = "japansFood"
//                
//            case 0: pinImage = "pinEmpty"
//                
//            default: pinImage  = "pinUnknow"
//                
//            }
//        }
//        
//        return pinImage
//    }
    
    
}



extension ViewController {
    //this section is handling Loocation
    
    func initializeLocationManager(){
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setCurrentLocation(latDelta:Double, longDelta:Double) {
        
        
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var location = CLLocationCoordinate2D()
        print("myLocationManager.location , \(myLocationManager.location)")
        
        if let current = myLocationManager.location {
            location.latitude = Double(current.coordinate.latitude)
            location.longitude = Double(current.coordinate.longitude)
            print("取得使用者GPS位置")
        }else{
//            Latitude: 25.0037154,
//            Longitude: 121.5145271,
            location.latitude = 25.0037154
            location.longitude = 121.5145271
//            location.latitude = 22.669248
//            location.longitude = 120.4861926
            print("無法取得使用者位置、改取得屏東火車站GPS位置")
        }
        
        print("北緯：\(location.latitude) 東經：\(location.longitude)")
        let center:CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion (center: center.coordinate, span:currentLocationSpan)
        
        self.mapView.setRegion(currentRegion, animated: true)
        
        print("currentRegion \(currentRegion)")
        self.location = location
        
    }
    
}


extension ViewController: CLLocationManagerDelegate {
    //get the authorization for location
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        myLocationManager.stopUpdatingLocation()
        
    }
    
    func authrizationStatus(){
        print("view did appear")
        let authrizationStatus = CLLocationManager.authorizationStatus()
        
        switch authrizationStatus {
            
        case .notDetermined:
            myLocationManager.requestWhenInUseAuthorization()
            myLocationManager.startUpdatingLocation()
            
        case .denied: //提示可以在設定中打開
            let alertController = UIAlertController(title: "定位權限以關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle:.alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController,animated: true, completion:nil)
            
        case .authorizedWhenInUse:
            myLocationManager.startUpdatingLocation()
            print("開始定位")
            
            
        default:
            print("Location authrization error")
            break
        }
        
        let myLocation:MKUserLocation = mapView.userLocation
        myLocation.title = "😏目前位置"
        
        setCurrentLocation(latDelta: 0.05, longDelta: 0.05)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let currentLocation: CLLocation = locations[0] as CLLocation
        print("didUpdateLocations: \(currentLocation)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            myLocationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}








