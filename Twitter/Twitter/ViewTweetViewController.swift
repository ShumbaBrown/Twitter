//
//  ViewTweetViewController.swift
//  Twitter
//
//  Created by Shumba Brown on 2/28/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ViewTweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var atnameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet?
    var retweeted: Bool = false
    var favorited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0, green: (172.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]


        profileImageView.setImageWith(self.tweet!.profileUrl!)
        screennameLabel.text = self.tweet!.screenName!
        atnameLabel.text = self.tweet!.atName!
        tweetTextLabel.text = self.tweet!.text!
        
        if tweet!.retweeted == true {
            self.retweeted = true
            retweetImageView.image = UIImage(named: "retweet-icon-green")
        }
        else {
            retweetImageView.image = UIImage(named: "retweet-icon")
        }
        retweetCountLabel.text = "\(tweet!.retweetCount)"
        
        if tweet!.favorited == true {
            self.favorited = true
            favoriteImageView.image = UIImage(named: "favor-icon-red")
        }
        else {
            favoriteImageView.image = UIImage(named: "favor-icon")
        }
        favoriteCountLabel.text = "\(tweet!.favoritesCount)"
        
        replyImageView.image = UIImage(named: "reply-icon")
        replyCountLabel.text = "0"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
