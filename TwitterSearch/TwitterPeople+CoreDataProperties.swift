//
//  TwitterPeople+CoreDataProperties.swift
//  TwitterSearch
//
//  Created by 吉安 on 30/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import Foundation
import CoreData


extension TwitterPeople {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterPeople> {
        return NSFetchRequest<TwitterPeople>(entityName: "TwitterPeople");
    }

    @NSManaged public var name: String?
    @NSManaged public var screenName: String?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension TwitterPeople {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: TweetEntity)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: TweetEntity)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
