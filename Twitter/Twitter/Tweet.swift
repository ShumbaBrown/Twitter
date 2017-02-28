//
//  Tweet.swift
//  Twitter
//
//  Created by Shumba Brown on 2/20/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileUrl: URL?
    var screenName: String?
    var atName: String?
    var favorited: Bool? = false
    var retweeted: Bool? = false
    var tweetID: String?
    
    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as? String
        
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        self.timeStamp = formatter.date(from: timeStampString!)
        
        let user = dictionary["user"] as? NSDictionary
        
        if let user = user {
            let profileurlstring = user["profile_image_url_https"] as? String
            if let profileurlstring = profileurlstring {
                self.profileUrl = URL(string: profileurlstring)
            }
            self.screenName = user["name"] as? String
            self.atName = "@\(user["screen_name"]!)"
        }
        
        let fav = dictionary["favorited"] as! Bool
        
        if fav == true {
            self.favorited = false
        }
        
        let ret = dictionary["retweeted"] as! Bool
        
        if ret == true {
            self.retweeted = false
        }
        
        self.tweetID = dictionary["id_str"] as? String
    }
    
    class func TweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        return tweets
    
    }
}
