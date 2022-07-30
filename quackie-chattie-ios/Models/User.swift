//
//  User.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/25/22.
//

import Foundation
import FirebaseAuth
import Firebase


class UserInformation {
    func setDispayName(user_name: String) {
        if let user = Auth.auth().currentUser {
            let profileUpdates = user.createProfileChangeRequest()
            profileUpdates.displayName = user_name
            profileUpdates.commitChanges { error in
                if error != nil {
                    print("Successfully updated display name for user [\(user.uid)] to [\(user_name)")
                }
            }
        }
    }
}
