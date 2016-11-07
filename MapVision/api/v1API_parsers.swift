//
//  v1API_parsers.swift
//  shakeYourFood
//
//  Created by Daniel Lee on 2016/11/5.
//  Copyright © 2016年 sohoGroup. All rights reserved.
//

import Foundation

class v1API_Parser: AnyObject {
    
    func parseReestaurant(restaurant resDic:[String : AnyObject]) -> restaurant {
        var result = restaurant();
        
        print("resDic : \(resDic)");
        
        //location
        if let location = resDic["location"] as? [String:Double]
        {
            if location["lat"] != nil && location["lng"] != nil
            {
                let loc : locate = locate(longitude: Double(location["lng"]! as NSNumber), latitude: Double(location["lat"]! as NSNumber));
                result.location = loc;
            }
        }else
        {
            print("restaurant location parse error");
        }
        
        //name
        if let name = resDic["name"] as? String
        {
            result.name = name;
            print("restaurant name : \(result.name)");
        }else
        {
            print("restaurant name parse error");
        }
        
        //place_id
        if let placeId = resDic["place_id"] as? String
        {
            result.place_id = placeId;
        }else
        {
            print("restaurant placeId parse error");
        }
        
        //vicinty
        if let addr = resDic["vicinity"] as? String
        {
            result.vicinity = addr;
        }else
        {
            print("restaurant vicinty parse error");
        }
        
        
        return result;
    }
    
    func parseFood(Food fooDic:[String : AnyObject]) -> food {
        var result = food();
        
        //id
        if let fooid = fooDic["id"] as? String
        {
            result.id = fooid;
        }else
        {
            print("food id parse error");
        }
        
        //name
        if let name = fooDic["name"] as? String
        {
            result.name = name;
            print("food name : \(result.name)");
        }else
        {
            print("food name parse error");
        }
        
        //place_id
        if let placeId = fooDic["place_id"] as? String
        {
            result.place_id = placeId;
        }else
        {
            print("food placeId parse error");
        }
        
        //price
        if let foodPrice = fooDic["price"] as? Double
        {
            result.price = foodPrice;
        }else
        {
            print("food price parse error");
        }
        
        //url
        if let foodUrl = fooDic["url"] as? String
        {
            result.url = foodUrl;
        }else
        {
            print("food url parse error");
        }
        
        return result;
    }
    
    private func convertFormat(stringOrig: String) -> Character {
        let subString = String(stringOrig.characters.split(separator: "U").map({$0})[1]); //split("U").map({$0})[1])
        let scalarValue = Int(subString);
        let scalar = UnicodeScalar(scalarValue!);
        return Character(scalar!);
    }
}

