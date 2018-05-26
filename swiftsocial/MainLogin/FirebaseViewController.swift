//
//  GoogleViewController.swift
//  swiftconcepts
//
//  Created by new on 23/05/18.
//  Copyright © 2018 yuvraj. All rights reserved.
//

import UIKit
import Firebase 

class FirebaseViewController: BaseViewController, ResponseDelegate, UITextFieldDelegate {
    
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var imagePlatform: UIImageView!
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var labelUserDetails: UILabel!
    @IBOutlet var labelError: UILabel! 
    
    var credential : AuthCredential?
    var platform : Platform?
    let fireAuth = FirebaseAuthenticator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlatformSpecificImage()
        labelError.isHidden = true
        
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
        fireAuth.delegate = self
        
    }
    
    func showPlatformSpecificImage(){
        imagePlatform.image = UIImage(named: (platform?.platformImage)!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textFieldUserName:
            textFieldPassword.becomeFirstResponder()
        case textFieldPassword:
            textFieldPassword.resignFirstResponder()
        default:
            textFieldPassword.resignFirstResponder()
        }
        labelError.isHidden = true
        return true
    }
    
    @IBAction func buttonFirebaseLogin(_ sender: Any) {
        
        let userName = textFieldUserName.text!
        let passWord = textFieldPassword.text!
        
        labelUserName.text = ""
        labelUserDetails.text = ""
        
        if(fireAuth.validateFields(username: userName , password: passWord, labelError: self.labelError)){
            showProgressIndicator()
            fireAuth.firebaseLogin(email: userName,password: passWord)
        }
    }
    
    @IBAction func buttonFirebaseSignUp(_ sender: Any) {
        
        let userName = textFieldUserName.text!
        let passWord = textFieldPassword.text!
        
        labelUserName.text = ""
        labelUserDetails.text = ""
        
        if(fireAuth.validateFields(username: userName , password: passWord, labelError: self.labelError)){
            showProgressIndicator()
            fireAuth.firebaseSignUp(email: userName,password: passWord)
        }
    } 
    
    func onApiResponse(user: AuthDataResult) {
        hideProgressIndicator()
        print(user)
        
        labelUserName.text = user.user.displayName
        labelUserDetails.text = user.user.email
    }
    
    func onErrorResponse(error: Error?) {
        hideProgressIndicator()
        print(error.debugDescription)
        labelUserName.text = error?.localizedDescription
        labelUserDetails.text = error.debugDescription
    }
    
    func performPlatformSpecificLogin(){
        //        switch(platform?.platformName){
        //        case "Google":
        //
        //            break;
        //
        //        case "Facebook":
        //
        //            break;
        //
        //        case "Twitter":
        //
        //            break;
        //
        //        case "Phone":
        //
        //            break;
        //
        //        case "Email":
        //
        //            break;
        //
        //        case "Github":
        //
        //            break;
        //
        //        default:
        //            print("text")
        //        }
    }
}
