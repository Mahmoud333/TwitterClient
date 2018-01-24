//
//  UIViewController+Extn.swift
//  GoalPost
//
//  Created by Mahmoud Hamad on 1/9/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit


extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        
        transition.subtype = kCATransitionFromRight    //where it should come from, from right to left
        
        self.view.window?.layer.add(transition, forKey: kCATransition) //its identifier that represents a transition animation.
        
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
    
}
