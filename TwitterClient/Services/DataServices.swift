//
//  DataService.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/21/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import TwitterKit
import SwiftyJSON
import RealmSwift
import Alamofire

var FOLLOWERS_next_cursor_str = ""

class DataServices {
    
    static var instace = DataServices()
    let userDefaults = UserDefaults.standard
    
    func fetchFollowers(nextCursor: Bool,completion: @escaping (Bool,[RealmFollowerr]?) -> ()) {//
        let screenName = userDefaults.value(forKey: "SCREEN_NAME")
        
        var url = "https://api.twitter.com/1.1/followers/list.json?screen_name=\(screenName!)&count=5"
        
        if nextCursor {
            url.append("&cursor=\(FOLLOWERS_next_cursor_str)")
        } else {
            url.append("&cursor=-1")
        }
        
        //"https://api.twitter.com/1.1/followers/list.json?cursor=-1&count=5&user_id=\(userID)"
        print("urlFollowers1: \(url)")
        
        //Get current logged in user
        let twitterClient = TWTRAPIClient.withCurrentUser()
        
        
        let request = twitterClient.urlRequest(withMethod: "GET",
                                               urlString: url,
                                               parameters: [:],
                                               error: nil)

        twitterClient.sendTwitterRequest(request, completion: { (response, data, connectionError) in
            
            if connectionError != nil || data == nil { completion(false, nil); print(connectionError?.localizedDescription); print(response.debugDescription); return }
            
            print("data: \(data)")
            let json2 = JSON(data ?? Data())
            print("json2: \(json2)")
            
            if json2 == nil { completion(false, nil) }
            
            
            FOLLOWERS_next_cursor_str = json2["next_cursor_str"].stringValue
            
            var followers = [RealmFollowerr]()
            
            for i in 0..<json2["users"].arrayValue.count {
                
                var follower = RealmFollowerr()
                follower.descriptionBio = json2["users"][i]["description"].stringValue
                follower.id = json2["users"][i]["id"].intValue
                follower.namee = json2["users"][i]["name"].stringValue
                follower.profile_banner_url = json2["users"][i]["profile_banner_url"].stringValue
                follower.profile_image_url = json2["users"][i]["profile_image_url_https"].stringValue
                follower.screen_name = json2["users"][i]["screen_name"].stringValue

                //Photos
                Alamofire.request(follower.profile_image_url.replacingOccurrences(of: "\\", with: "")).responseData(completionHandler: { (response1) in
                    
                    follower.profile_image_url_Data = response1.data!
                    
                    
                    Alamofire.request(follower.profile_banner_url.replacingOccurrences(of: "\\", with: "")).responseData(completionHandler: { (response2) in
                        
                        follower.profile_banner_url_Data = response2.data!
                        
                        
                        followers.append(follower)
                        
                        if i == json2["users"].arrayValue.count - 1 {
                            completion(true, followers)
                        }
                    })
                })
            }
        })
    }    
    
    func veryifyUser(completion: @escaping (Bool,String?) -> ()) {
        let url = "https://api.twitter.com/1.1/account/verify_credentials.json"
        print(url)
        
        let twitterClient = TWTRAPIClient.withCurrentUser()
        
        let request = twitterClient.urlRequest(withMethod: "GET",
                                               urlString: url,
                                               parameters: [:],
                                               error: nil)
        
        twitterClient.sendTwitterRequest(request, completion: { (response, data, connectionError) in
            
            if connectionError != nil || data == nil { completion(false, nil); print(connectionError?.localizedDescription); print(response.debugDescription); return }
            
            
            print("data: \(data)")
            let json = JSON(data!)
            print("json: \(json)")
            
            if json == nil { completion(false, nil) }
            
            let screenName = json["screen_name"].stringValue
            
            completion(true, screenName)
        })
    }

    func fetchUserTweets(screenName: String,count: Int ,completion: @escaping (Bool,[RealmTweet]?) -> ()) {
        
        //Get your user timeline
        let urlHome = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(screenName)&count=\(count)"
        
        
        //Get current logged in user
        let twitterClient = TWTRAPIClient.withCurrentUser()
        
        let request = twitterClient.urlRequest(withMethod: "GET",
                                               urlString: urlHome,
                                               parameters: [:],
                                               error: nil)

        twitterClient.sendTwitterRequest(request, completion: { (response, data, connectionError) in
            
            if connectionError != nil || data == nil { completion(false, nil); print(connectionError?.localizedDescription); print(response.debugDescription); return }
            
            print("data: \(data)")
            let json = JSON(data!)
            print("Tweets json: \(json)")
            
            
            var allTweets = [RealmTweet]()
            
            for i in 0..<json.arrayValue.count {
                
                var tweeta = RealmTweet()
                tweeta.profile_image_url_https = json[i]["user"]["profile_image_url_https"].stringValue
                tweeta.id = json[i]["user"]["id"].intValue
                tweeta.name = json[i]["user"]["name"].stringValue
                tweeta.screen_name = json[i]["user"]["screen_name"].stringValue
                tweeta.verified = json[i]["user"]["verified"].boolValue
                
                tweeta.favorite_count = json[i]["favorite_count"].intValue
                tweeta.retweet_count = json[i]["retweet_count"].intValue
                tweeta.text = json[i]["text"].stringValue
                tweeta.created_at = json[i]["created_at"].stringValue
                tweeta.tweetID = json[i]["id"].intValue
                
                if let extendedEntities = json[i]["extended_entities"].dictionary {
                    tweeta.image1 = json[i]["extended_entities"]["media"][0]["media_url_https"].stringValue
                    tweeta.image2 = json[i]["extended_entities"]["media"][1]["media_url_https"].stringValue
                    tweeta.image3 = json[i]["extended_entities"]["media"][2]["media_url_https"].stringValue
                    tweeta.image4 = json[i]["extended_entities"]["media"][3]["media_url_https"].stringValue
                }
                
                allTweets.append(tweeta)
            }
            
            completion(true,allTweets)
        })        
    }
}
