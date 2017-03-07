//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Shumba Brown on 2/20/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var tweets: [Tweet] = []
    var isMoreDataLoading = false
    var segueTweetCell: TweetCell?
    var segueTweet: Tweet?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0, green: (172.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // ... Code to load more results ...
                loadMoreData()
            }
        }
        
    }
    
    
    func loadMoreData() {
        // ... Create the NSURLRequest (myRequest) ...
        
        /*
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTaskWithRequest(request: myRequest, completionHandler: {(data, response, error) in
                                                                        
            // Update flag
            self.isMoreDataLoading = false
            
            // ... Use the new data to update the data source ...
                                                                        
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
        })
        task.resume()
 */
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        cell.populateCell(tweet: tweets[indexPath.row])
        cell.tweet = tweets[indexPath.row]
        
        cell.profileImageView.isUserInteractionEnabled = true
        let cellTapRecognizerProfile = UITapGestureRecognizer(target: self, action: #selector(TweetsViewController.openProfilePage(recognizer:)))
        cell.profileImageView.addGestureRecognizer(cellTapRecognizerProfile)
        
        cell.textLabel?.isUserInteractionEnabled = true
        let cellTapRecognizerTweetText = UITapGestureRecognizer(target: self, action: #selector(TweetsViewController.openTweet(recognizer:)))
        cell.textLabel?.addGestureRecognizer(cellTapRecognizerTweetText)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func openProfilePage(recognizer: UIGestureRecognizer) {
        
        if recognizer.state == UIGestureRecognizerState.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = self.tableView.indexPathForRow(at: swipeLocation){
                if let swipedCell = self.tableView.cellForRow(at: swipedIndexPath) {
                    self.segueTweetCell = swipedCell as? TweetCell
                    
                }
            }
        }
        self.performSegue(withIdentifier: "openProfileSegue", sender: self)
    }
    
    func openTweet(recognizer: UIGestureRecognizer) {
        
        if recognizer.state == UIGestureRecognizerState.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = self.tableView.indexPathForRow(at: swipeLocation){
                if let swipedCell = self.tableView.cellForRow(at: swipedIndexPath) {
                    self.segueTweetCell = swipedCell as? TweetCell
                    self.segueTweet = self.segueTweetCell?.tweet!
                    
                }
            }
        }
        self.performSegue(withIdentifier: "openTweetFromFeed", sender: self)
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openProfileSegue" {
            let navController = segue.destination as! UINavigationController
            let profileView = navController.topViewController as! ProfileViewController
            profileView.userID = self.segueTweetCell?.userID
        }
        if segue.identifier == "openTweetFromFeed" {
            let navController = segue.destination as! UINavigationController
            let tweetView = navController.topViewController as! ViewTweetViewController
            tweetView.tweet = self.segueTweet!
        }
        /*
        if segue.identifier == "openComposeView" {
            let navController = segue.destination as! UINavigationController
            let composeView = navController.topViewController as! ProfileViewController
        }
 */
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
