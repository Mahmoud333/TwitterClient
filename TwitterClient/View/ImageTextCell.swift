//
//  ImageTextCell.swift
//  TwitterDemo
//
//  Created by Mahmoud Hamad on 1/18/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit

class ImageTextCell: UITableViewCell {

    @IBOutlet weak var ProfileImageV: MAImageV!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var screenNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    
    @IBOutlet weak var firstImageV: MAImageV!
    @IBOutlet weak var secondImageV: MAImageV!
    @IBOutlet weak var thirdImageV: MAImageV!
    @IBOutlet weak var fourthImageV: MAImageV!
    @IBOutlet weak var secondStackView: UIStackView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //if its three images then hide the fourthImageV
        //if its two images then hide thirdImageV and fourthImageV
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
