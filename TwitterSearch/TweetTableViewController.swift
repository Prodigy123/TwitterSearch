//
//  TweetTableViewController.swift
//  TwitterSearch
//
//  Created by 吉安 on 28/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController,UITextFieldDelegate {
    
    var manageObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.newBackgroundContext()
    var tweets = [Array<Tweet>](){
        didSet{
            tableView.reloadData()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    @IBOutlet weak var twitterSearchText: UITextField!{
        didSet{
            twitterSearchText.delegate = self
            twitterSearchText.text = searchText
        }
    }
    var searchText: String?{
        didSet{
            tweets.removeAll()
            getTweets()
            title = searchText
        }
    }
    var request: Request?{
        if let query = searchText, !query.isEmpty {
            return Request(search: query, count: 100)
        }
        return nil
    }
    var lastRequest: Request?
    private func getTweets(){
        if let requestFromNet = request{
            let lastRequest = requestFromNet
            requestFromNet.fetchTweets{[weak weakSelf = self ] newTweet in
                DispatchQueue.main.async {
                    if requestFromNet == lastRequest{
                        if !newTweet.isEmpty{
                            weakSelf?.tweets.insert(newTweet, at: 0)
                            weakSelf?.updataDatebase(tweets: newTweet)
                        }
                    }
                }
            }
        }
    }
    private func updataDatebase(tweets: [Tweet]){
        manageObjectContext?.perform {
            for oneTweet in tweets{
                _ = TweetEntity.insertWithTweet(tweet: oneTweet, inmanageObjectContext: self.manageObjectContext!)
                do{
                    try self.manageObjectContext?.save()
                }catch let error{
                    print("eroor balalala! \(error)")
                }
            }
            self.printTheDataCount()
            print("done printing data")
        }
    }
    private func printTheDataCount()->Void{
        manageObjectContext?.perform {
            if let theOutcome = try? self.manageObjectContext!.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "TweetEntity"))
            {
                print("\(theOutcome) tweets")
            }
            if let usersCount = try? self.manageObjectContext!.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterPeople"))
            {print("\(usersCount) Users")}
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet = tweets[indexPath.section][indexPath.row]
        if let contant = cell as? TweetTableViewCell{
            contant.tweet = tweet
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPeopleCount"{
            if let peopleTVC = segue.destination as? PeopleTableViewController{
                    peopleTVC.mention = searchText
                    peopleTVC.managedObjectContext = manageObjectContext
            }
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
