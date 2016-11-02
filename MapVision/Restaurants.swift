//
//  Restaurants.swift
//  MapVision
//
//  Created by 陳 冠禎 on 2016/11/2.
//  Copyright © 2016年 陳 冠禎. All rights reserved.
//

import Foundation
class Rastaurants {
    
    var restaurants:[restaurant]{
    return _restaurants
    }
    
    var _restaurants:[restaurant] = []
    
    
    var restaurant:restaurant{
        return _restaurant
    }
    var _restaurant:restaurant = restaurant(name: "", longitude: 0.0, latitude: 0.0)
    

    typealias DownloadComplete = () -> ()
    
    func downloadData(completed:@escaping DownloadComplete){
        var array:[restaurant] = []
        
        //demo Data
        _restaurant.name = "first"
        _restaurant.latitude = 22.679248
        _restaurant.longitude = 120.4861926
        array.append(_restaurant)
        
        _restaurant.name = "second"
        _restaurant.latitude = 22.669248
        _restaurant.longitude = 120.4961926
        array.append(_restaurant)
        
        

        self._restaurants = array //
        print("資料下載完成 \(array)")
        completed()
    }
//
    
    struct restaurant {
        
        var name: String?
        var longitude:Double
        var latitude:Double

        
//        var type:String?
        
//        var location:CLLocationCoordinate2D?
//
//        static func deserialize(_ node: XMLIndexer) throws -> Station { return try Station(
//            name: node["StationName"].value(),
//            location: node["StationAddress"].value(),
//            parkNumber: node["StationNums2"].value(),
//            currentBikeNumber: node["StationNums1"].value(),
//            //                        longitude: node["StationLon"].value(),
//            //                        latitude: node["StationLat"].value()
//            longitude: node["StationLat"].value(),
//            latitude: node["StationLon"].value()
//            
//            )
//        }
    }
    
    

}
