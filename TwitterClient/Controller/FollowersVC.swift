//
//  FollowersVC.swift
//  TwitterClient
//
//  Created by Mahmoud Hamad on 1/21/18.
//  Copyright © 2018 Mahmoud SMGL. All rights reserved.
//

import UIKit
import RealmSwift

class FollowersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var realm: Realm?
    
    var followerss = [RealmFollowerr]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self; tableView.dataSource = self
        
        
        do {
            realm = try Realm()
        } catch {
            debugPrint("Realm catch error: \(error.localizedDescription)")
        }
        
        
        if !Connectivity.isConnectedToInternet() {
            
            followerss = (realm?.objects(RealmFollowerr.self).toFollowersArray())!
            //.toArray(ofType: RealmFollowerr.self) as! [RealmFollowerr]
            //.toFollowersArray())!
            
            
            tableView.reloadData()
            
            print("Realm No Internet Connection")
        } else {
            
            fetchFollowers(nextCursor: false)
        }
    }
    
    func fetchFollowers(nextCursor: Bool) {
        DataServices.instace.fetchFollowers(nextCursor: nextCursor) { (success, fetchedRealmFollowers) in
            if success {
                
                self.followerss += fetchedRealmFollowers!
                self.tableView.reloadData()
                
                
                print(fetchedRealmFollowers)
                
                for tweet in fetchedRealmFollowers! {
                    
                    //save it
                    do {
                        try self.realm?.write {
                            //just save it to realm
                            //self.realm?.add(fetchedRealmFollowers!)
                            
                            //save it and update it if its alrady existed
                            //self.realm?.create(RealmFollowerr.self, value: fetchedRealmFollowers!, update: true)
                            self.realm?.create(RealmFollowerr.self, value: tweet, update: true)
                        }
                    }   catch {
                        debugPrint("Realm error saving643: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
}

extension FollowersVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell") as? FollowersCell {
            
            cell.nickNameLbl.text = followerss[indexPath.row].namee
            cell.screenNameLbl.text = "@\(followerss[indexPath.row].screen_name)"
            cell.bioTextV.text = followerss[indexPath.row].descriptionBio
            //Profile
            cell.profileIV.image = UIImage(data: followerss[indexPath.row].profile_image_url_Data!)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerss.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //"ProfileVC"
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        dvc.initTheVC(realmFollower: followerss[indexPath.row])
        presentDetail(dvc)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
            spinner.startAnimating()
            
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(100))
            spinner.backgroundColor = UIColor.lightGray
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            
            
            if Connectivity.isConnectedToInternet() {
                fetchFollowers(nextCursor: true)
            } else {
                //Do Nothing
            }
        }
    }
    
}
