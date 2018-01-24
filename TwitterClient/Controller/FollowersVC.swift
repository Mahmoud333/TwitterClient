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
            //.toArray(ofType: RealmFollower.self) as! [RealmFollower]
            
            tableView.reloadData()
            
            print("Realm No Internet Connection")
        } else {
            do {
                
                try realm?.write {
                    realm?.deleteAll()
                }
            }   catch {
                debugPrint("Realm error deleting273: \(error.localizedDescription)")
            }
            
            fetchFollowers()
        }
    }
    
    func fetchFollowers() {
        DataServices.instace.fetchFollowers { (success, fetchedRealmFollowers) in
            if success {
                
                self.followerss = fetchedRealmFollowers!
                self.tableView.reloadData()
                
                
                print(fetchedRealmFollowers)
                
                //save it
                do {
                    try self.realm?.write {
                        //just save it to realm
                        self.realm?.add(fetchedRealmFollowers!)
                        
                        //save it and update it if its alrady existed
                        //self.realm?.create(RealmFollowerr.self, value: fetchedRealmFollowers!, update: true)
                    }
                }   catch {
                    debugPrint("Realm error saving643: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchAnotherFollowers() {
        DataServices.instace.fetchAnotherFollowers { (success, fetchedRealmFollowers) in
            if success {
                self.followerss += fetchedRealmFollowers!
                self.tableView.reloadData()
                
                //save it
                do {
                    
                    try! self.realm?.write {
                        
                        //just save it to realm
                        self.realm?.add(fetchedRealmFollowers!)
                        
                        //save it and update it if its alrady existed
                        //self.realm?.create(RealmFollowerr.self, value: fetchedRealmFollowers!, update: true)
                    }
                }   catch {
                    debugPrint("Realm error saving123: \(error.localizedDescription)")
                }
                
            }
        }
    }
    
}

extension FollowersVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell") as? FollowersCell {
            
            cell.nickNameLbl.text = followerss[indexPath.row].namee
            cell.screenNameLbl.text = followerss[indexPath.row].screen_name
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
        present(dvc, animated: true, completion: nil)
        
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
                fetchAnotherFollowers()
            } else {
                //Do Nothing
            }
        }
    }
    
}
