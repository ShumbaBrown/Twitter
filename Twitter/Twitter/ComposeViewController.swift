//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Shumba Brown on 2/28/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var atnameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0, green: (172.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTweet(_ sender: Any) {
        // perform tweet request
        TwitterClient.sharedInstance?.postTweet(message: tweetTextField.text!, inReplyToStatusId: nil, success: { (tweet: Tweet) -> (Void) in
            print(tweet.text!)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        tweetTextField.text = ""
        
        performSegue(withIdentifier: "backToTimelineFromCompose", sender: self)
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
