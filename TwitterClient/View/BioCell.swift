//
//  BioCell.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/24/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit

class BioCell: UITableViewCell {

    @IBOutlet weak var profileImage: MAImageV!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var bioTextV: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configuerCell(follower: RealmFollowerr) {
        nameLbl.text = follower.namee
        nicknameLbl.text = "@\(follower.screen_name)"
        bioTextV.text = follower.descriptionBio
        profileImage.image = UIImage(data: follower.profile_image_url_Data!)
    }
}
