//
//  ProfileVC.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/22/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Alamofire

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileVC: UIViewController {
    

    
    @IBOutlet weak var nameHeaderLbl: UILabel!
    @IBOutlet weak var bioView: UIView!
    
    
    @IBOutlet weak var profileIV: MAImageV!
    @IBOutlet weak var headerIV: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var screenNameLbl: UILabel!
    @IBOutlet weak var descriptionBioTV: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    
    
    var profile: RealmFollowerr?
    var tweetss = [RealmTweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self; tableView.dataSource = self
        

        
        // Header - Image
        //Add Image to the header
        headerImageView = UIImageView(frame: headerIV.bounds)
        headerImageView?.image = UIImage(named: "porsche")
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerIV.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        //Add Blur to header view
        headerBlurImageView = UIImageView(frame: headerIV.bounds)
        headerBlurImageView?.image = UIImage(named: "porsche")?.blurImage()
        headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerBlurImageView?.alpha = 0.0
        headerIV.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        headerIV.clipsToBounds = true
        
        //Profile Data
        profileIV.image = UIImage(data: profile!.profile_image_url_Data ?? Data())
        headerImageView?.image = UIImage(data: profile!.profile_banner_url_Data ?? Data())
        headerBlurImageView?.image = UIImage(data: profile!.profile_banner_url_Data ?? Data())?.blurImage()
        nameLbl.text = profile?.namee
        nameHeaderLbl.text = profile?.namee
        screenNameLbl.text = profile?.screen_name
        descriptionBioTV.text = profile?.descriptionBio
        
        fetchTweetsForThatUser()
    }
    
    func initTheVC(realmFollower: RealmFollowerr) {
        profile = realmFollower
        
    }
    
    @IBAction func profileImageTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: (profile?.profile_image_url.replacingOccurrences(of: "\\", with: ""))!)!, options: [:], completionHandler: nil)
    }
    @IBAction func headerImageTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: (profile?.profile_banner_url.replacingOccurrences(of: "\\", with: ""))!)!, options: [:], completionHandler: nil)
    }
    func fetchTweetsForThatUser() {
        
        DataServices.instace.fetchUserTweets(screenName: profile!.screen_name, count: 10) { (success, fetchedRealmTweets) in
            
            DispatchQueue.global(qos: .userInteractive).async { //.userInteractive or userInitiated
                
                for tweet in fetchedRealmTweets! {
                    let profileImage = tweet.profile_image_url_https.replacingOccurrences(of: "\\", with: "")
                    let imageUrl1 = tweet.image1.replacingOccurrences(of: "\\", with: "")
                    let imageUrl2 = tweet.image2.replacingOccurrences(of: "\\", with: "")
                    let imageUrl3 = tweet.image3.replacingOccurrences(of: "\\", with: "")
                    let imageUrl4 = tweet.image4.replacingOccurrences(of: "\\", with: "")
                    
                    if !self.tweetss.contains(tweet) {
                        
                        //Profile
                        Alamofire.request(profileImage).responseData(completionHandler: { (response1) in
                            tweet.profile_image_url_httpsData = response1.data!
                            
                            //Attached 1
                            Alamofire.request(imageUrl1).responseData(completionHandler: { (response2) in
                                if response2.data! != Data() {
                                    tweet.image1Data = response2.data!
                                }
                                
                                //Attached 2
                                Alamofire.request(imageUrl2).responseData(completionHandler: { (response3) in
                                    if response3.data! != Data() {
                                        tweet.image2Data = response3.data!
                                    }
                                    
                                    //Attached 3
                                    Alamofire.request(imageUrl3).responseData(completionHandler: { (response4) in
                                        if response4.data! != Data() {
                                            tweet.image3Data = response4.data!
                                        }
                                        
                                        //Attached 4
                                        Alamofire.request(imageUrl4).responseData(completionHandler: { (response5) in
                                            if response5.data! != Data() {
                                                tweet.image4Data = response5.data!
                                            }
                                            
                                            self.tweetss.append(tweet)
                                            
                                            print(self.tweetss)
                                            
                                            DispatchQueue.main.async {
                                                
                                                
                                                self.tableView.reloadData()
                                            }
                                        })
                                    })
                                })
                            })
                        })
                    }}
            }
        }
    }
    
    
    func fetchAnotherTweets(maxId: Int, sinceID: Int) {
        // oldest |- - - - - - since_id[. . . . . . . . . . . . . . .]max_id - - - - - -| latest
        
        //max_id: Returns results with an ID less than (that is, older than) or equal to the specified ID.
        //since_id: Returns results with an ID greater than (that is, more recent than) the specified ID. There are limits to the number of Tweets that can be accessed through the API. If the limit of Tweets has occured since the since_id, the since_id will be forced to the oldest ID available.
        DataServices.instace.fetchAnotherUserTweets(screenName: profile!.screen_name, max_id: maxId, sinceId: sinceID) { (success, fetchedRealmTweets) in
            
            
            if success {
                
                for tweet in fetchedRealmTweets! {
                    let profileImage = tweet.profile_image_url_https.replacingOccurrences(of: "\\", with: "")
                    let imageUrl1 = tweet.image1.replacingOccurrences(of: "\\", with: "")
                    let imageUrl2 = tweet.image2.replacingOccurrences(of: "\\", with: "")
                    let imageUrl3 = tweet.image3.replacingOccurrences(of: "\\", with: "")
                    let imageUrl4 = tweet.image4.replacingOccurrences(of: "\\", with: "")
                    
                    if !self.tweetss.contains(tweet) {
                        
                        //Profile
                        Alamofire.request(profileImage).responseData(completionHandler: { (response1) in
                            tweet.profile_image_url_httpsData = response1.data!
                            
                            //Attached 1
                            Alamofire.request(imageUrl1).responseData(completionHandler: { (response2) in
                                if response2.data! != Data() {
                                    tweet.image1Data = response2.data!
                                }
                                
                                //Attached 2
                                Alamofire.request(imageUrl2).responseData(completionHandler: { (response3) in
                                    if response3.data! != Data() {
                                        tweet.image2Data = response3.data!
                                    }
                                    
                                    //Attached 3
                                    Alamofire.request(imageUrl3).responseData(completionHandler: { (response4) in
                                        if response4.data! != Data() {
                                            tweet.image3Data = response4.data!
                                        }
                                        
                                        //Attached 4
                                        Alamofire.request(imageUrl4).responseData(completionHandler: { (response5) in
                                            if response5.data! != Data() {
                                                tweet.image4Data = response5.data!
                                            }
                                            
                                            self.tweetss.append(tweet)
                                            
                                            print(self.tweetss)
                                            self.tableView.reloadData()
                                        })
                                    })
                                })
                            })
                        })
                    }
                }
                
            }
        }
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tweetss[indexPath.row].image1.characters.count == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as? TextCell {
                let tweeta = tweetss[indexPath.row]
                
                
                cell.ProfileImageV.image = UIImage(data:  tweeta.profile_image_url_httpsData ?? Data())
                
                cell.descriptionLbl.text = tweeta.text
                cell.screenNameLbl.text = "@\(tweeta.screen_name)"
                cell.nicknameLabel.text = tweeta.name
                cell.dateLbl.text = tweeta.created_at
                
                return cell
            }
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTextCell") as? ImageTextCell {
                
                let tweeta = tweetss[indexPath.row]
                
                cell.descriptionLbl.text = tweeta.text
                
                cell.ProfileImageV.image = UIImage(data: tweeta.profile_image_url_httpsData ?? Data())
                
                
                cell.descriptionLbl.text = tweeta.text
                cell.screenNameLbl.text = "@\(tweeta.screen_name)"
                cell.nicknameLabel.text = tweeta.name
                cell.dateLbl.text = tweeta.created_at
                
                //Attached Images
                cell.firstImageV.image = UIImage(data: tweeta.image1Data ?? Data())
                
                if tweeta.image2Data != nil {  //.image2Data != nil {
                    
                    cell.secondImageV.isHidden = false
                    cell.secondImageV.image = UIImage(data: tweeta.image2Data!)
                } else { cell.secondImageV.isHidden = true}
                
                if tweeta.image3Data != nil {
                    
                    cell.thirdImageV.isHidden = false
                    cell.thirdImageV.image = UIImage(data: tweeta.image3Data!)
                } else { cell.thirdImageV.isHidden = true }
                
                if tweeta.image4Data != nil {
                    
                    cell.fourthImageV.isHidden = false
                    cell.fourthImageV.image = UIImage(data: tweeta.image4Data!)
                } else { cell.fourthImageV.isHidden = true}
                
                if tweeta.image2Data == nil  && tweeta.image3Data == nil {
                    cell.secondStackView.isHidden = true
                } else {
                    cell.secondStackView.isHidden = false
                }
                
                return cell
            }
        }
        
        return ImageTextCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetss.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity

        
        // PULL DOWN -----------------
        
        if offset < 0 {
            print("offset < 0")
            //if scrollView.isEqual(tableView) {
            //    if offset <= 40.0 {tableView.isScrollEnabled = false; }
            //}
            
            //for header
            let headerScaleFactor:CGFloat = -(offset) / headerIV.bounds.height
            let headerSizevariation = ((headerIV.bounds.height * (1.0 + headerScaleFactor)) - headerIV.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            

            headerIV.layer.transform = headerTransform
            

            /*UIView.animate(withDuration: 2.0, animations: {
                self.tableView.transform = CGAffineTransform(translationX: 0, y: 300)
                self.bioView.transform = CGAffineTransform(translationX: 0, y: 300)
            })*/
            
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            print("else offset < 0")
            print(offset)
            //if offset >= 230.0 { tableView.isScrollEnabled = true; }
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / profileIV.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((profileIV.bounds.height * (1.0 + avatarScaleFactor)) - profileIV.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            
            

            /*UIView.animate(withDuration: 2.0, animations: {
                self.tableView.transform = CGAffineTransform(translationX: 0, y: -300)
                self.bioView.transform = CGAffineTransform(translationX: 0, y: -300)
            })*/
            
            if offset <= offset_HeaderStop {
                
                if profileIV.layer.zPosition < headerIV.layer.zPosition{
                    headerIV.layer.zPosition = 0
                }
                
            }else {
                if profileIV.layer.zPosition >= headerIV.layer.zPosition{
                    headerIV.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
        headerIV.layer.transform = headerTransform
        profileIV.layer.transform = avatarTransform

        bioView.isHidden = true
        
        //bioTopConstraint.constant = 0
        //tableVTopConstraint.constant = 0
        UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
         })
        
    }
    

}
