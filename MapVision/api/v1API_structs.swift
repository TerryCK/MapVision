//
//  v1API_structs.swift
//  shakeYourFood
//
//  Created by Daniel Lee on 2016/11/4.
//  Copyright © 2016年 sohoGroup. All rights reserved.
//

import Foundation

struct restaurant {
    
    var name        : String?
    var location    : locate?
    var place_id    : String?
    var vicinity    : String?
    
}

struct food {
    var id          : String?
    var name        : String?
    var place_id    : String?
    var price       : Double?
    var url         : String?
}

struct locate {
    
    var longitude   : Double
    var latitude    : Double

}
