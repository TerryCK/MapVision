//
//  v1API.swift
//  shakeYourFood
//
//  Created by Daniel Lee on 2016/11/2.
//  Copyright © 2016年 sohoGroup. All rights reserved.
//

import Foundation

enum enjoy_status_action: Int {
    case tooFar         = 0
    case tooExpensive   = 1
    case dislike        = 2
    case go             = 4
}



//MARK: shake api

class v1API: AnyObject {
    
    private let uid = "minithon";
    private let http = httpWork();
    
    //MARK: GET /v1/search
    /**
     ///call back struct(restaurant, food), parsed from server responce data.
     
     - parameters:
     - Latitude: user current lat.
     - Longitude: user current lng.
     - callback: with struct restaurant() and food()
     - Example:
     if you want to call restaurant's name in the callback block, can directly code res?.name to print out the parameter.
     
     example :
     {
     "respCode": "SUCCESS",
     "message": "",
     "restaurant": {
     "place_id": "ChIJ79nqreMUaTQRlg7RZmOHmNY",
     "name": "肯德基KFC-台中沙鹿餐廳",
     "vicinity": "No. 127, Shatian Road, Shalu District",
     "location": {
     "lat": 24.235836,
     "lng": 120.559077
     }
     },
     "food": {
     "place_id" = "ChIJ79nqreMUaTQRlg7RZmOHmNY",
     "id": "f000001",
     "name": "雞腿飯",
     "price": 65,
     "url": "http://www.jengjong.tw/upload/food/20140311185704212.jpg"
     }
     }
     */
    func getNearbyRestaurant(Latitude lat:Float, Longitude lng:Float, callback : @escaping (_ restaurantData : restaurant?, _ foodData : food?)->Void){
        
        http.httpRequestWithURLParam(withRoute: "/v1/search", HTTPMethod: "GET", parameters: ["uid":uid, "lat":"\(lat)", "lng":"\(lng)"], callback: {(data,res,err) in
            if err == nil{
                
                do{
                    
                    let responseData:[String:AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject];
                    
                    //print("responseData:\(responseData)");
                    
                    
                    //parse data
                    var res   : restaurant = restaurant();
                    var foo   : food = food();
                    
                    if responseData["respCode"] is String && responseData["respCode"] as? String == "SUCCESS"{
                        
                        for (key, value) in responseData
                        {
                            if key == "restaurant" && value is [String : AnyObject]
                            {
                                //parse restaurant
                                
                                res = v1API_Parser().parseReestaurant(restaurant: value as! [String : AnyObject]);
                                
                            }else if key == "food"
                            {
                                //parse food
                                foo = v1API_Parser().parseFood(Food: value as! [String : AnyObject]);
                                
                            }else if key == "message"
                            {
                                print("\n message from server : \(value) \n");
                            }
                        }
                        
                        callback(res, foo);
                        
                    }else{
                        callback(nil, nil);
                    }
                    
                    
                    
                    
                    //callback(responseData);
                    
                    
                }catch{
                    
                    print("catch");
                    callback(nil, nil);
                    
                }
                
            }else{
                
                print("error:\(err)");
                callback(nil, nil);
                
            }
            
        })
    }
    
    
    //MARK: GET /v1/search/action
    /*
     Using this after user feedback their feelings about the restaurant, and callback full message in [] type for now.
     example:
     
     {
     "respCode": "SUCCESS",
     "message": "",
     " restaurant": {
     "place_id": "ChIJ79nqreMUaTQRlg7RZmOHmNY",
     "name": "肯德基KFC-台中沙鹿餐廳",
     "vicinity": "No. 127, Shatian Road, Shalu District",
     "location": {
     "lat": 24.235836,
     "lng": 120.559077
     }
     },
     "food": {
     "place_id" = "ChIJ79nqreMUaTQRlg7RZmOHmNY",
     "id": "f000001",
     "name": "雞腿飯",
     "price": 65,
     "url": "http://www.jengjong.tw/upload/food/20140311185704212.jpg"
     }
     }
     
     */
    func furtherAction(Latitude lat:Float, Longitude lng:Float, place_id pid:String, food_id fid:String, action:enjoy_status_action, callback : @escaping (_ restaurantData : restaurant?, _ foodData : food?)->Void){
        
        http.httpRequestWithURLParam(withRoute: "/v1/search/action", HTTPMethod: "GET", parameters: ["uid":uid, "lat":"\(lat)", "lng":"\(lng)", "place_id":"\(pid)", "foodId":"\(fid)", "action":"\(action.rawValue)"], callback: {(data,res,err) in
            if err == nil{
                
                do{
                    
                    let responseData:[String:AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject];
                    
                    print("responseData:\(responseData)");
                    
                    //callback(responseData);
                    //parse data
                    var res   : restaurant = restaurant();
                    var foo   : food = food();
                    
                    if responseData["respCode"] is String && responseData["respCode"] as? String == "SUCCESS"{
                        
                        for (key, value) in responseData
                        {
                            if key == "restaurant" && value is [String : AnyObject]
                            {
                                //parse restaurant
                                
                                res = v1API_Parser().parseReestaurant(restaurant: value as! [String : AnyObject]);
                                
                            }else if key == "food"
                            {
                                //parse food
                                foo = v1API_Parser().parseFood(Food: value as! [String : AnyObject]);
                                
                            }else if key == "message"
                            {
                                print("\n message from server : \(value). \n");
                            }
                        }
                        
                        callback(res, foo);
                        
                    }else{
                        callback(nil, nil);
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    print("catch");
                    callback(nil, nil);
                    
                }
                
            }else{
                
                print("error:\(err)");
                callback(nil, nil);
                
            }
            
        })
        
    }
    
    
    
    //MARK: Map api
    
    //GET /v1/restaurant
    /**
     To get the list of restaurants nearby the input location.
     */
    func getNearbyRestaurantList(Latitude lat:Float, Longitude lng:Float, callback : @escaping (_ restaurantDataList : [restaurant]?)->Void)
    {
        http.httpRequestWithURLParam(withRoute: "/v1/restaurant", HTTPMethod: "GET", parameters: ["uid":uid, "lat":"\(lat)", "lng":"\(lng)"], callback: {(data, res, err)->Void in
            
            if(data == nil)
            {
                print("no data.");
                callback(nil);
            }
            do{
                let responseData : [String:AnyObject]? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject];
                print("responseData : \(responseData)");
                
                if responseData == nil
                {
                    print("json parse failed.");
                    callback(nil);
                }
                
                for (Key, Value) in responseData!
                {
                    if (Key == "respCode" && Value is String && ((Value as? String) != "SUCCESS"))
                    {
                        print("respCode is not SUCCESS.");
                        callback(nil);
                    }else if(Key == "message" && Value is String)
                    {
                        print("Message from server : \(Value as! String)");
                    }else if(Key == "restaurantList" && Value is [[String:AnyObject]])
                    {
                        let resTempList : [[String:AnyObject]]? = Value as? [[String:AnyObject]];
                        var reslistForCallBack : [restaurant]? = [];
                        if resTempList == nil
                        {
                            print("templist is nil")
                            callback(nil);
                        }
                        
                        for res in resTempList!
                        {
                            let tempRes : restaurant = v1API_Parser().parseReestaurant(restaurant: res);
                            reslistForCallBack?.append(tempRes);
                        }
                        
                        callback(reslistForCallBack);
                    }
                }
                
                
            }catch
            {
                callback(nil);
            }
        })
    }
}
