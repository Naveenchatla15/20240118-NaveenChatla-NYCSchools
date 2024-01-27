//
//  User.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 22/01/24.
//

import UIKit
import CoreData

class User: NSManagedObject {

    @NSManaged var firstName : String?
    @NSManaged var lastName : String?
    @NSManaged var mobileNo : String?
    @NSManaged var gender : String?
    @NSManaged var email : String?
}
