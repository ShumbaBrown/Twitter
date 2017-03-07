//
//  TwitterClient.swift
//  Twitter
//
//  Created by Shumba Brown on 2/20/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I got a token")
            
            
            let token = requestToken!.token
            //print(token!)
            
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)")! as URL
            
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            
            self.loginFailure?(error!)
        })
        
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        TwitterClient.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("I got the token")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
            
            
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })

    }

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "AYFkYBX1hOTnf7jb40FkpIibT", consumerSecret: "b6hi5W8EMuSzsaWJ4iMvdSaP0SAjDfw6akpbpflBPMnKJYj2L6")
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json?count=200", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            let tweetDictionary = response as! [NSDictionary]
            
            let tweets = Tweet.TweetsWithArray(dictionaries: tweetDictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func userTimeLine(userID: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/user_timeline.json?user_id=\(userID)&count=200", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            let tweetDictionary = response as! [NSDictionary]
            
            let tweets = Tweet.TweetsWithArray(dictionaries: tweetDictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    /*
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json?count=200", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            let tweetDictionary = response as! [NSDictionary]
            
            let tweets = Tweet.TweetsWithArray(dictionaries: tweetDictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    */
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    func retweet(tweetID: String) {
        post("1.1/statuses/retweet/\(tweetID).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func deretweet(tweetID: String) {
        post("1.1/statuses/destroy/\(tweetID).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func favorite(tweetID: String) {
        post("1.1/favorites/create.json?id=\(tweetID)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

            
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func defavorite(tweetID: String) {
        post("1.1/favorites/destroy.json?id=\(tweetID)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func getProfile(userID: String, success: @escaping (Profile) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/users/show.json?user_id=\(userID)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            print(userID)
            let profileDictionary = response as! NSDictionary
            let profile = Profile(dictionary: profileDictionary)
            
            success(profile)
            
        }) { (tast: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            
            failure(error)
            
        }
        
        
    }
    
    
    
    func postTweet(message: String, inReplyToStatusId: String?, success: @escaping (Tweet) -> (Void), failure: @escaping (Error) -> Void) {
        
        let parameters: [String: String] = {
            if let inReplyToStatusId = inReplyToStatusId {
                return ["status": message, "in_reply_to_status_id": "\(inReplyToStatusId)"]
            } else {
                return ["status": message]
            }
        }()
        
        post("1.1/statuses/update.json",
             parameters: parameters,
             progress: nil,
             success: { _, response in
                if let dictionary = response as? [String: AnyObject] {
                    let tweet = Tweet(dictionary: dictionary as NSDictionary)
                    success(tweet)
                } },
             failure: { (_, error: Error) in
                failure(error)
        })
    }
}


