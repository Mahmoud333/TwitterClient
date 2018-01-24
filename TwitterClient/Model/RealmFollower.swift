//
//  RealmFollower.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/21/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import Foundation
import RealmSwift


class RealmFollowerr: Object {
    
    @objc dynamic var screen_name: String = ""
    @objc dynamic var namee: String = ""
    @objc dynamic var descriptionBio: String = ""
    //@objc dynamic var profile_image_url_https: String = ""
    //@objc dynamic var profile_background_image_url_https: String = ""
    @objc dynamic var profile_image_url: String = ""
    @objc dynamic var profile_banner_url: String = ""
    @objc dynamic var profile_image_url_Data: Data? = nil
    @objc dynamic var profile_banner_url_Data: Data? = nil

    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String {
        return "id"
    }
    
}
