//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Mahmoud Hamad on 1/18/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTweet: Object {
    //Profile
    @objc dynamic var profile_image_url_https: String = ""
    @objc dynamic var profile_image_url_httpsData: Data? = nil
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screen_name: String = ""
    @objc dynamic var verified:Bool = false
    
    //the tweet itself
    @objc dynamic var favorite_count:Int = 0
    @objc dynamic var retweet_count:Int = 0
    @objc dynamic var text:String = ""
    @objc dynamic var created_at:String = ""
    @objc dynamic var tweetID:Int = 0
    
    //The Images
    @objc dynamic var image1: String = ""
    @objc dynamic var image2: String = ""
    @objc dynamic var image3: String = ""
    @objc dynamic var image4: String = ""
    
    @objc dynamic var image1Data: Data? = nil
    @objc dynamic var image2Data: Data? = nil
    @objc dynamic var image3Data: Data? = nil
    @objc dynamic var image4Data: Data? = nil
    
    override class func primaryKey() -> String {
        return "tweetID"
    }
    
    //Equatable
    public static func ==(lhs:RealmTweet,rhs:RealmTweet) -> Bool {
        return lhs.id == rhs.id
    }
}

