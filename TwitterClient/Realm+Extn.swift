//
//  Realm+Extn.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/23/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
    
    func toFollowersArray() -> [RealmFollowerr]{
        
        var array = [RealmFollowerr]()
        
        for i in 0..<count {
            array.append(self[i] as! RealmFollowerr)
        }
        return array
    }
}



