//
//  RandomUser.swift
//  简单通信
//
//  Created by 方瑾 on 2019/3/7.
//  Copyright © 2019 方瑾. All rights reserved.
//

import Foundation
struct RandomUser : Decodable {
    var results: [singleUser]?
}
struct singleUser : Decodable {
    var email: String?
    var phone: String?
    var name : Name?
    var location : Location?
    var dob : Dob?
    var picture : Picture?
}
struct Name : Decodable {
    var first : String?
    var last : String?
}
struct Location : Decodable {
    var state : String?
    var street : String?
}

struct Dob : Decodable {
    var date:String
}
struct Picture : Decodable {
    var large : String?
}
