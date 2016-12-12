//
//  TweetEntity+CoreDataClass.swift
//  TwitterSearch
//
//  Created by 吉安 on 30/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//
import Foundation
import CoreData
import Twitter
@objc(TweetEntity)
public class TweetEntity: NSManagedObject {
    class func insertWithTweet(tweet: Tweet, inmanageObjectContext context: NSManagedObjectContext)->TweetEntity?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TweetEntity")
        request.predicate = NSPredicate(format: "unique = %@", tweet.id)
        if let outcome =  (try? context.fetch(request))?.first as? TweetEntity{
            return outcome
        }else if let insertOne = NSEntityDescription.insertNewObject(forEntityName: "TweetEntity", into: context) as? TweetEntity{
            insertOne.posted = tweet.created as NSDate?
            insertOne.text = tweet.text
            insertOne.unique = tweet.id
            insertOne.twitterpeople = TwitterPeople.insertWithTwitterPeople(tweet: tweet, inmanageObjectContext: context)
            return insertOne
        }
        return nil
    }
}

