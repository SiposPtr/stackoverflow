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
    
    func init(firUser: User) { //error: Keyword 'init' cannot be used as an identifier here
        self.email = firUser.email ?? ""
        self.isEmailVerified = ""
        self.sendEmailVerification = ""
    }
}
