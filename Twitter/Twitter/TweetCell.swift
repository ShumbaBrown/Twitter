//
//  TweetCell.swift
//  Twitter
//
//  Created by Shumba Brown on 2/20/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var atNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var stringID: String?
    var retweeted: Bool = false
    var favorited: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.retweetImageView.isUserInteractionEnabled = true
        let cellTapRecognizerRetweet = UITapGestureRecognizer(target: self, action: #selector(TweetCell.retweet(_:)))
        cellTapRecognizerRetweet.cancelsTouchesInView = false
        retweetImageView.addGestureRecognizer(cellTapRecognizerRetweet)
        
        self.favoriteImageView.isUserInteractionEnabled = true
        let cellTapRecognizerFavorite = UITapGestureRecognizer(target: self, action: #selector(TweetCell.favorite(_:)))
        favoriteImageView.addGestureRecognizer(cellTapRecognizerFavorite)
        
        //let cellTapRecognizerFavorite = UITapGestureRecognizer(target: self, action: #selector(TweetCell.onTapFavorite(_:)))
        //cellTapRecognizerFavorite.cancelsTouchesInView = false
        //favoriteImageView.addGestureRecognizer(cellTapRecognizerFavorite)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCell(tweet: Tweet) -> () {
        
    
        
        profileImageView.layer.cornerRadius = 10.0
        profileImageView.clipsToBounds = true
        
        profileImageView.setImageWith(tweet.profileUrl!)
        screenNameLabel.text = tweet.screenName
        atNameLabel.text = tweet.atName
        tweetLabel.text = tweet.text
        
        self.stringID = tweet.tweetID
        
        if tweet.retweeted == true {
            self.retweeted = true
            retweetImageView.image = UIImage(named: "retweet-icon-green")
        }
        else {
            retweetImageView.image = UIImage(named: "retweet-icon")
        }
        retweetCountLabel.text = "\(tweet.retweetCount)"
        
        if tweet.favorited == true {
            self.favorited = true
            favoriteImageView.image = UIImage(named: "favor-icon-red")
        }
        else {
            favoriteImageView.image = UIImage(named: "favor-icon")
        }
        favoriteCountLabel.text = "\(tweet.favoritesCount)"
        
        replyImageView.image = UIImage(named: "reply-icon")
        replyCountLabel.text = ""
        
        let currentDate = Date()
        let time = currentDate.timeIntervalSince1970
        
        let tweetTime = tweet.timeStamp?.timeIntervalSince1970
        
        let difference = Int(time - tweetTime!)
        
        print("current time : \(currentDate)")
        print("time : \(tweet.timeStamp!)")
        
        if (difference < 60) {
            timeLabel.text = "1m"
        }
        else if (difference < 3600) {
            let update = Int(difference/60)
            
            timeLabel.text = "\(update)m"
        }
        else if (difference < 84600) {
            let update = Int((difference/60)/60)
            
            timeLabel.text = "\(update)h"
        }
        
        
        print(difference)
    }
    
    func retweet(_ sender: Any) {
        if self.retweeted {
            TwitterClient.sharedInstance?.deretweet(tweetID: self.stringID!)
            retweetImageView.image = UIImage(named: "retweet-icon")
            let retweet_count = Int(self.retweetCountLabel.text!)! - 1
            
            retweetCountLabel.text = "\(retweet_count)"
            
            self.retweeted = false
            print("unretweet!")

        }
        else {
            TwitterClient.sharedInstance?.retweet(tweetID: self.stringID!)
            retweetImageView.image = UIImage(named: "retweet-icon-green")
            let retweet_count = Int(self.retweetCountLabel.text!)! + 1
            
            retweetCountLabel.text = "\(retweet_count)"
            
            self.retweeted = true
            print("retweet!")

        }
        
        
    }
    
    func favorite(_ sender: Any) {
        if self.favorited {
            TwitterClient.sharedInstance?.defavorite(tweetID: self.stringID!)
            favoriteImageView.image = UIImage(named: "favor-icon")
            let favorite_count = Int(self.favoriteCountLabel.text!)! - 1
            
            favoriteCountLabel.text = "\(favorite_count)"
            
            self.favorited = false
            print("defavourite!")
        }
        else {
            TwitterClient.sharedInstance?.favorite(tweetID: self.stringID!)
            favoriteImageView.image = UIImage(named: "favor-icon-red")
            let favorite_count = Int(self.favoriteCountLabel.text!)! + 1
            
            favoriteCountLabel.text = "\(favorite_count)"
            
            self.favorited = true
            print("favourite!")

        }
        
        
    }

}
