//
//  Profile.swift
//  Twitter
//
//  Created by Shumba Brown on 2/28/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class Profile: NSObject {

    var userID: String?
    var name: String?
    var screenName: String?
    var profileBio: String?
    var followerCount: Int?
    var followingCount: Int?
    var tweetCount: Int?
    var verified: Bool = false
    var backgroundImageURL: URL?
    var profileImageURL: URL?
    var following: Bool = false
    var followRequestSent: Bool = false
    
    init(dictionary: NSDictionary) {
        userID = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileBio = dictionary["descriptionf"] as? String
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetCount = dictionary["statuses_count"] as? Int
        //verified = dictionary["verified"] as! Bool
        //following = dictionary["following"] as! Bool
        //followRequestSent = dictionary["follow_request_sent"] as! Bool
        
        let backgroundImageString = dictionary["profile_banner_url"] as? String
        if let backgroundImageString = backgroundImageString {
            self.backgroundImageURL = URL(string: backgroundImageString)
            
        }
        
        let profileImageString = dictionary["profile_image_url_https"] as? String
        if let profileImageString = profileImageString {
            self.profileImageURL = URL(string: profileImageString)
        }
        
        
    }
    
}
