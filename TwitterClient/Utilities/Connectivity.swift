//
//  Connectivity.swift
//  Marvel Vezeeta
//
//  Created by Mahmoud Hamad on 11/5/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
