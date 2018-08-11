//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Анастасия Латыш on 06/08/2018.
//  Copyright © 2018 Fabric. All rights reserved.
//

import UIKit
import SafariServices

class MentionTableViewController: UITableViewController {

    var tweet :Tweet? {
        didSet {
            guard let tweet = tweet else { return }
            title = tweet.user.screenName
            mentionSections = initMensionSections(from: tweet)
            tableView.reloadData()
        }
    }
    
    private var mentionSections: [MentionSection] = []
    
    private struct MentionSection {
        var type: String
        var mentions: [mentionItem]
    }
    
    private enum mentionItem {
    case keyword(String)
    case image(URL, Double)
    }

    private func initMensionSections(from tweet:Tweet)-> [MentionSection]{
        var mentionSections = [MentionSection]()
        
        if  tweet.media.count > 0 {
            mentionSections.append(MentionSection(type: "Images",
                                                  mentions: tweet.media.map{ mentionItem.image($0.url, $0.aspectRatio)}))
        }
        if tweet.urls.count > 0 {
            mentionSections.append(MentionSection(type: "URLs",
                                                  mentions: tweet.urls.map{ mentionItem.keyword($0.keyword)}))
        }
        if tweet.hashtags.count > 0 {
            mentionSections.append(MentionSection(type: "Hashtags",
                                                  mentions: tweet.hashtags.map{ mentionItem.keyword($0.keyword)}))
        }
        if tweet.userMentions.count > 0 {
            mentionSections.append(MentionSection(type: "Users",
                                                  mentions: tweet.userMentions.map{ mentionItem.keyword($0.keyword)}))
        }
        return mentionSections
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mentionSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentionSections[section].mentions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        // Configure the cell...
        switch mention{
        case .keyword(let keyword):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "KeywordCell",for: indexPath)
             cell.textLabel?.text = keyword
            return cell
        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ImageCell", for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.imageUrl = url
            }
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return mentionSections[section].type
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    private struct Storyboard {
        static let KeywordCell = "Keyword Cell"
        static let ImageCell = "Image Cell"
        
        static let KeywordSegue = "From Keyword"
        static let ImageSegue = "Show Image"
        
    }
    
    
    // MARK: - Navigation from KeyWord
    override func shouldPerformSegue(withIdentifier identifier: String?,
                                     sender: Any?) -> Bool {
        if identifier == Storyboard.KeywordSegue {
            if let cell = sender as? UITableViewCell,
                let indexPath =  tableView.indexPath(for: cell),
                mentionSections[indexPath.section].type == "URLs" {
                
                if let urlString = cell.textLabel?.text,
                    let url = URL(string:urlString) {
                    
                    let safariVC = SFSafariViewController(url: url)
                    present(safariVC, animated: true, completion: nil)
                    
             }
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            if identifier == Storyboard.KeywordSegue{
                if let ttvc = segue.destination as? TweetTableViewController,
                let cell = sender as? UITableViewCell,
                    let text = cell.textLabel?.text {
                    ttvc.searchText = text
                }
            }
        }
    }
    

}
