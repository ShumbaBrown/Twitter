//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Shumba Brown on 2/28/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var atnameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var userID: String?
    var tweets: [Tweet] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 10.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3.0
        profileImageView.clipsToBounds = true

        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0, green: (172.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.getProfile(userID: userID!, success: { (profile: Profile) in
            self.populateProfile(profile: profile)
        }, failure: { (error: Error) in
            
            print(error.localizedDescription)
            
        })
        TwitterClient.sharedInstance?.userTimeLine(userID: userID!, success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        print(userID!)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateProfile(profile: Profile) -> () {
        
        self.bannerImageView.setImageWith(profile.backgroundImageURL!)
        self.profileImageView.setImageWith(profile.profileImageURL!)
        self.screennameLabel.text = profile.screenName!
        self.atnameLabel.text = "@\(profile.name!)"
        self.tweetCountLabel.text = "\(profile.tweetCount!)"
        self.followersCountLabel.text = "\(profile.followerCount!)"
        self.followingCountLabel.text = "\(profile.followingCount!)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTweetCell", for: indexPath) as! TweetCell
        
        cell.populateCell(tweet: tweets[indexPath.row])
        
        return cell
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
