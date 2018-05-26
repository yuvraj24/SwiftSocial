//
//  GoogleAuthentication.swift
//  swiftconcepts
//
//  Created by new on 24/05/18.
//  Copyright © 2018 yuvraj. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseAuthenticator {
    
    var delegate : ResponseDelegate?
    
    func validateFields(username : String, password : String, labelError : UILabel) -> Bool {
        
        guard username.count != 0 else{
            labelError.isHidden = false
            labelError.text = "Please enter valid Username"
            return false
        }
        
        guard password.count >= 6 else{
            labelError.isHidden = false
            labelError.text = "Please enter valid Password"
            return false
        }
        
        labelError.isHidden = true
        labelError.text = ""
        return true
    }
    
    func firebaseSignUp(email : String, password : String){
        Auth.auth().createUserAndRetrieveData(withEmail: email, password: password) { (user, error) in
            guard error != nil else{
                self.delegate?.onApiResponse(user: (user)!)
                return
            }
            self.delegate?.onErrorResponse(error: error)
        }
    }
    
    func firebaseLogin(email : String, password : String){
        Auth.auth().signInAndRetrieveData(withEmail: email, password: password) { (user, error) in
            guard error != nil else{
                self.delegate?.onApiResponse(user: (user)!)
                return
            }
            self.delegate?.onErrorResponse(error: error)
        }
    }
}
