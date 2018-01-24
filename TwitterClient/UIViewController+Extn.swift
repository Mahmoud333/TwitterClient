//
//  UIViewController+Extn.swift
//  GoalPost
//
//  Created by Mahmoud Hamad on 1/9/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit

//CATransition
//present and dismiss detail with
//will override the animation that happens
extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush //pushing the current VC off and replacing it with new one
                                            //slide over the old viewcontroller
        transition.subtype = kCATransitionFromRight    //where it should come from, from right to left
        
        self.view.window?.layer.add(transition, forKey: kCATransition) //its identifier that represents a transition animation.
        
        //animated: true, it will make the default animation
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        
        transition.subtype = kCATransitionFromLeft
        
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    //presentingViewController?.presentSecondaryDetail(finishGoalVC)
    //tell viewcontroller that presented us to dismiss this current viewcontroller and instead present this viewcontroller
    //dismiss your presented VC and intead present this
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        //constant that hold the presentedViewController
        //the view controller thats presented (viewed)
        guard let presentedViewController = presentedViewController else {return}
        print("presentedViewController: \(presentedViewController)")
        
        presentedViewController.dismiss(animated: false) {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
        
    }
}
