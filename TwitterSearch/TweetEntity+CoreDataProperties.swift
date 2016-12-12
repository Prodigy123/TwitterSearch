//
//  TweetEntity+CoreDataProperties.swift
//  TwitterSearch
//
//  Created by 吉安 on 30/11/2016.
//  Copyright © 2016 An Ji. All rights reserved.
//

import Foundation
import CoreData


extension TweetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetEntity> {
        return NSFetchRequest<TweetEntity>(entityName: "TweetEntity");
    }

    @NSManaged public var text: String?
    @NSManaged public var posted: NSDate?
    @NSManaged public var unique: String?
    @NSManaged public var twitterpeople: TwitterPeople?

}
