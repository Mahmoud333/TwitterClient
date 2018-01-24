//
//  ProfileVC.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/22/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 45.0 // The distance between the bottom of the Header and the top of the White Label, was 35.0 

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
    
    var realm: Realm?
    
    var profile: RealmFollowerr?
    var tweetss = [RealmTweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self; tableView.dataSource = self
        
        //Setting Things
        
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
        
        
        //Realm Part
        do {
            realm = try Realm()
        } catch {
            debugPrint("Realm catch error: \(error.localizedDescription)")
        }
        
        
        //1- fetch all RealmTweets
        //2- filter them the ones who have same screenName as profile

        tweetss = (realm?.objects(RealmTweet.self).toTweetsArray().filter({ (realmTweet) -> Bool in
            print("Realm: \(realmTweet.screen_name) == \(profile?.screen_name)")
            return realmTweet.screen_name == profile?.screen_name
        }))!
        print("realm tweets: \(tweetss)")
        
        if !Connectivity.isConnectedToInternet() {
            
            tableView.reloadData()
            
            print("Realm No Internet Connection")
        } else {
            
            fetchTweetsForThatUser()
        }

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
                                            
                                            //add it in our array
                                            self.tweetss.append(tweet)
                                            
                                            do {
                                                
                                                try self.realm?.write {
                                                    //save the tweet and update it if its alrady existed
                                                    self.realm?.create(RealmTweet.self, value: tweet, update: true)
                                                }
                                            }   catch {
                                                debugPrint("Realm error deleting436: \(error.localizedDescription)")
                                            }
                                            
                                            print(self.tweetss)
                                            
                                            self.tableView.reloadData()
                                        })
                                    })
                                })
                            })
                        })
                    }}
            }
        }
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismissDetail()
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BioCell") as? BioCell {
                cell.configuerCell(follower: profile!)
                return cell
            }
            
        } else {
            
            if tweetss[indexPath.row - 1].image1.characters.count == 0 {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as? TextCell {
                    let tweeta = tweetss[indexPath.row - 1]
                    
                    
                    cell.ProfileImageV.image = UIImage(data:  tweeta.profile_image_url_httpsData ?? Data())
                    
                    cell.descriptionLbl.text = tweeta.text
                    cell.screenNameLbl.text = "@\(tweeta.screen_name)"
                    cell.nicknameLabel.text = tweeta.name
                    cell.dateLbl.text = tweeta.created_at
                    
                    return cell
                }
                
            } else {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTextCell") as? ImageTextCell {
                    
                    let tweeta = tweetss[indexPath.row - 1]
                    
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
        }
        
        return ImageTextCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + tweetss.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BioCell else {return}
        let profileIVV = cell.profileImage
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            print("offset < 0") //Scrolling up the tableview
            
            //for header
            let headerScaleFactor:CGFloat = -(offset) / headerIV.bounds.height
            let headerSizevariation = ((headerIV.bounds.height * (1.0 + headerScaleFactor)) - headerIV.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            
            headerIV.layer.transform = headerTransform

        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            print("else offset < 0") //Scrolling down the tableview
            print(offset)
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / (profileIVV?.bounds.height)! / 1.4 // Slow down the animation
            let avatarSizeVariation = ((profileIV.bounds.height * (1.0 + avatarScaleFactor)) - (profileIVV?.bounds.height)!) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            

            
            if offset <= offset_HeaderStop {
                
                if (profileIVV?.layer.zPosition)! < headerIV.layer.zPosition{
                    headerIV.layer.zPosition = 0
                }
                
            }else {
                if (profileIVV?.layer.zPosition)! >= headerIV.layer.zPosition{
                    headerIV.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
        headerIV.layer.transform = headerTransform
        profileIVV?.layer.transform = avatarTransform
        
    }
    
    
}
