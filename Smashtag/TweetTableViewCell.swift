//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
//import Twitter

class TweetTableViewCell: UITableViewCell
{
    // outlets to the UI components in our Custom UITableViewCell
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    // public API of this UITableViewCell subclass
    // each row in the table has its own instance of this class
    // and each instance will have its own tweet to show
    // as set by this var
    var tweet: Tweet? { didSet { updateUI() } }
    
    struct Palette {
        static let hashtagColor = UIColor.blue
        static let userColor = UIColor.red
        static let urlColor = UIColor.green
    }
    
    func setTextLabel(tweet: Tweet?)-> NSMutableAttributedString {
        guard let tweet = tweet else {return NSMutableAttributedString(string: "")}
        let tweetText = tweet.text
        let attributedText = NSMutableAttributedString(string: tweetText)
        
        attributedText.setMentionsColor(mentions: tweet.hashtags, color: Palette.hashtagColor)
        attributedText.setMentionsColor(mentions: tweet.urls, color: Palette.urlColor)
        attributedText.setMentionsColor(mentions: tweet.userMentions, color: Palette.userColor)
        return attributedText
    }
    
 
    // whenever our public API tweet is set
    // we just update our outlets using this method
    private func updateUI() {
   /*    if let tweetT = tweet {
        let colorText = tweet!.text
        var atr = NSMutableAttributedString(string: colorText)
            atr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: tweetT.urls.nsrange)
        }*/
        tweetTextLabel?.attributedText = setTextLabel(tweet: tweet)
        tweetUserLabel?.text = tweet?.user.description
    
        
        if let profileImageURL = tweet?.user.profileImageURL {
            // FIXME: blocks main thread
            if let imageData = try? Data(contentsOf: profileImageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}

private extension NSMutableAttributedString {
    func setMentionsColor(mentions: [Mention], color: UIColor){
        for mention in mentions {
            addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: mention.nsrange)
        }
    }
}
