//
//  TweetTableViewCell.swift
//  TwitterSearch
//
//  Created by 吉安 on 28/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit
import Twitter
class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        var lastTweet: Tweet?
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {   lastTweet = tweet
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            tweetScreenNameLabel?.text = "\(tweet.user)"
            let formatter = DateFormatter()
            if NSDate().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {[weak weakSelf = self] in
                if  let profileImageURL = tweet.user.profileImageURL{
                    let imageData = NSData(contentsOf: profileImageURL)
                    DispatchQueue.main.async {
                        if tweet == lastTweet{
                            if ((imageData as? Data) != nil){
                            weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData as! Data )
                            }
                        }
                    }
                }
            }
        }
    }
}





