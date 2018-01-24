//
//  TextImageCell.swift
//  TwitterDemo
//
//  Created by Mahmoud Hamad on 1/18/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    @IBOutlet weak var ProfileImageV: MAImageV!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var screenNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
