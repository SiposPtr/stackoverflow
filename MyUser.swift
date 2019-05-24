//
//  MyUser.swift
//  SiposSocialMedia
//
//  Created by Sipos Péter on 2019. 05. 24..
//  Copyright © 2019. Sipos Péter. All rights reserved.
//

import UIKit
import Firebase

class MyUser: NSObject {
    var email: String?
    var isEmailVerified: String?
    var sendEmailVerification: String?
    
    func init(firUser: User) {
        self.email = firUser.email ?? "" // not exactly sure about the
        self.isEmailVerified = ""
        self.sendEmailVerification = ""
    }
}
