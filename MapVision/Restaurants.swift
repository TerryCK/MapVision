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
    var _restaurant:restaurant = restaurant(name: "", location: Rastaurants.locate.init(longitude: 0.0, latitude: 0.0), place_id: "", vicinity: "")

    typealias DownloadComplete = () -> ()
    
    func downloadData(completed:@escaping DownloadComplete){
        var array:[restaurant] = []
        
        //demo Data
        _restaurant.name = "first"
        _restaurant.location?.latitude = 22.679248
        _restaurant.location?.longitude = 120.4861926
        array.append(_restaurant)
        
        _restaurant.name = "second"
        _restaurant.location?.latitude = 22.669248
        _restaurant.location?.longitude = 120.4961926
        array.append(_restaurant)
        
        

        self._restaurants = array //
        print("資料下載完成 \(array)")
        completed()
    }
//
    
    struct restaurant {
        
        var name        : String?
        var location    : locate?
        var place_id    : String?
        var vicinity    : String?
        

    }
    
    
    struct food {
        var id          : Int16?
        var name        : String?
        var place_id    : String?
        var price       : Double?
        var url         : String?
    }
    
    struct locate {
        
        var longitude   : Double
        var latitude    : Double
        
    }


}
