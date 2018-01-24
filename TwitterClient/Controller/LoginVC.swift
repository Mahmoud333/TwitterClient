//
//  ViewController.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/21/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON


class LoginVC: UIViewController {
    
    @IBOutlet weak var twitterLogoIV: UIImageView!
    
    let userDefault = UserDefaults.standard
    
    var loginButton: TWTRLogInButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginButton = TWTRLogInButton { (session, error) in
            
            if session != nil {
                
                print("Signed in as \(session?.userName)")
                
                
                self.getScreenName()
            } else {
                print("session == nil")
                debugPrint("Error: \(error?.localizedDescription)")
            }
        }
        
        
        loginButton?.center = CGPoint(x: view.bounds.width/2, y: self.view.frame.height*0.85)
        view.addSubview(loginButton!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if TWTRTwitter.sharedInstance().sessionStore.session()?.userID != nil, userDefault.string(forKey: "SCREEN_NAME") != nil {
            loginButton?.isHidden = true
            
            print("Signed in as \(TWTRTwitter.sharedInstance().sessionStore.session()?.userID)")
            
            loggedINAnimation()
        }
    }
    
    func getScreenName() {
        DataServices.instace.veryifyUser { (success, screenName) in
            if success {
                
                self.userDefault.set(screenName!, forKey: "SCREEN_NAME")
                
                //Animate
                self.loggedINAnimation()
            }
        }
    }
    
    func loggedINAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                
                self.twitterLogoIV.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            }, completion: { (success) in
                
                UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
                    
                    self.twitterLogoIV.transform = CGAffineTransform(scaleX: 30.0, y: 30.0)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        //Go to Next VC
                        self.performSegue(withIdentifier: "GoToFollowersVC", sender: nil)
                    }
                    
                }, completion: { (completed) in
                    if completed {
                        
                    }
                })
            })
        }
    }
    
}

