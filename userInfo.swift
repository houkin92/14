//
//  userInfo.swift
//  简单通信
//
//  Created by 方瑾 on 2019/3/6.
//  Copyright © 2019 方瑾. All rights reserved.
//

import Foundation
struct userInfo {
    var name : String?
    var email : String?
    var birth : String?
    var address : String?
    var phone : String?
    init(name:String,email:String,birth:String,address:String,phone:String) {
        self.name = name
        self.email = email
        self.birth = birth
        self.address = address
        self.phone = phone
    }
}
