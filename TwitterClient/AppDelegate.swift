//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/21/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Set it
        TWTRTwitter.sharedInstance().start(withConsumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
        
        return true
    }

    //for Log in Redirect when we signin on safari and go back to app
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

