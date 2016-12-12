//
//  TwitterPeople+CoreDataClass.swift
//  TwitterSearch
//
//  Created by 吉安 on 30/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import Foundation
import CoreData
import Twitter
@objc(TwitterPeople)
public class TwitterPeople: NSManagedObject {
    class func insertWithTwitterPeople(tweet: Tweet, inmanageObjectContext context: NSManagedObjectContext)->TwitterPeople?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterPeople")
        request.predicate = NSPredicate(format: "screenName = %@", tweet.user.screenName)
        if let outcome =  (try? context.fetch(request))?.first as? TwitterPeople{
            return outcome
        }else if let insertOne = NSEntityDescription.insertNewObject(forEntityName: "TwitterPeople", into: context) as? TwitterPeople{
            insertOne.name = tweet.user.name
            insertOne.screenName = tweet.user.screenName
            return insertOne
        }
        return nil
    }
}
