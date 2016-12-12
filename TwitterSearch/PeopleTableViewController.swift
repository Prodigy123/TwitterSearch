//
//  PeopleTableViewController.swift
//  TwitterSearch
//
//  Created by 吉安 on 01/12/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import UIKit
import CoreData
class PeopleTableViewController: CoreDataTableViewController {
    var mention: String?{didSet{updateUI()}}
    var managedObjectContext: NSManagedObjectContext?{didSet{updateUI()}}
    
    private func updateUI(){
        if let context = managedObjectContext, (mention?.characters.count)! > 0 {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterPeople")
            request.predicate = NSPredicate(format: "any tweets.text contains %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)
                ))]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        } else {fetchedResultsController = nil}
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseOne", for: indexPath)
        if let oneInfo = self.fetchedResultsController?.object(at: indexPath) as? TwitterPeople{
            managedObjectContext?.performAndWait {
                            cell.textLabel?.text = oneInfo.screenName
             }
            if let count = getTheNum(user: oneInfo){
                cell.detailTextLabel?.text = (count==1) ? "1 tweet" : "\(count) tweets"
            }else{cell.detailTextLabel?.text = ""}
        }
        return cell
    }
    private func getTheNum(user: TwitterPeople)->Int?{
        var count: Int?
        user.managedObjectContext?.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TweetEntity")
            request.predicate = NSPredicate(format: "text contains[c] %@ and twitterpeople = %@", self.mention!, user)
            count = try! user.managedObjectContext?.count(for: request)
        }
        return count
    }
}
