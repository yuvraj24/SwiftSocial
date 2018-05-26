//
//  ViewController.swift
//  swiftconcepts
//
//  Created by new on 18/05/18.
//  Copyright © 2018 yuvraj. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: BaseViewController, FBSDKLoginButtonDelegate, ResponseDelegate ,
SocialDelegate, GIDSignInDelegate, GIDSignInUIDelegate{
    
    @IBOutlet var imageSocial: UIImageView!
    @IBOutlet var loginButton: FBSDKLoginButton!
    @IBOutlet var textUserName: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var labelError: UILabel!
    @IBOutlet var googleButton: GIDSignInButton!
    
    
    let fireAuth : FirebaseAuthenticator = FirebaseAuthenticator()
    let socialAuth : SocialAuthenticator = SocialAuthenticator()
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        labelError.isHidden = true
        
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
        loginButton.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        fireAuth.delegate = self
        socialAuth.delegate = self
        
        guard FBSDKAccessToken.current() == nil else {
            // User is logged in, use 'accessToken' here.
            showProgressIndicator()
            socialAuth.facebookLogin()
            return
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        //        showProgressIndicator()
    }
    
    @IBAction func buttonFirebaseLogin(_ sender: Any) {
        
        let userName = textUserName.text!
        let passWord = textPassword.text!
        
        if(fireAuth.validateFields(username: userName , password: passWord, labelError: self.labelError)){
            showProgressIndicator()
            fireAuth.firebaseLogin(email: userName,password: passWord)
        }
    } 
    
    @IBAction func buttonOpenSignUp(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: nil)
    }
    
    // FIREBASE LOGIN API -----
    
    func onApiResponse(user: AuthDataResult) {
        hideProgressIndicator()
        print(user)
        labelError.text = "Login Successful : "+user.user.email!+""
    }
    
    func onErrorResponse(error: Error?) {
        hideProgressIndicator()
        print(error!.localizedDescription)
        labelError.isHidden = false;
        labelError.text = "Failed : "+error!.localizedDescription+""
    }
    
    // FACEBOOK LOGIN API -----
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        hideProgressIndicator()
        print("LOGOUT")
        self.labelError.text = ""
        self.textUserName.text = ""
        self.textPassword.text = ""
        self.imageSocial.image = UIImage(named: "login.png")
        self.imageSocial.clipsToBounds = false
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print("Will Logout")
        return true
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        guard error != nil else{
            showProgressIndicator()
            print("LOGIN SUCCESSFULL")
            socialAuth.facebookLogin()
            return
        }
        
        onFBErrorResponse(error : error)
        return
    }
    
    func onFBSuccessResponse(user: Any) {
        print(user)
        
        if let userDataDict = user as? NSDictionary {
            let first_name = userDataDict["first_name"] as? String
            _ = userDataDict["id"] as? String
            let last_name = userDataDict["last_name"] as? String
            let pictDict =  userDataDict["picture"] as? NSDictionary
            let pictureUrl = pictDict?["data"] as? NSDictionary
            let picture = pictureUrl?["url"] as? String
            
            labelError.isHidden = false;
            labelError.text = "Profile : "+first_name!+" "+last_name!+""
            
            URLSession.shared.dataTask(with: NSURL(string: picture!)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.imageSocial.image = image
                    self.imageSocial.layer.borderWidth = 1
                    self.imageSocial.layer.masksToBounds = false
                    self.imageSocial.layer.borderColor = UIColor.clear.cgColor
                    self.imageSocial.layer.cornerRadius = self.imageSocial.frame.height/2
                    self.imageSocial.clipsToBounds = true
                })
                
            }).resume()
            
        }
        hideProgressIndicator()
    }
    
    func onFBErrorResponse(error: Error?) {
        hideProgressIndicator()
        print(error?.localizedDescription as Any)
        labelError.isHidden = false;
        labelError.text = "Failed : "+(error?.localizedDescription)!+""
        self.imageSocial.image = UIImage(named: "login.png")
    }
    
    // GOOGLE LOGIN API ----- 
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(user)
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            print("User id is "+userId!+"")
            
            let idToken = user.authentication.idToken // Safe to send to the server
            print("Authentication idToken is "+idToken!+"")
            let fullName = user.profile.name
            print("User full name is "+fullName!+"")
            let givenName = user.profile.givenName
            print("User given profile name is "+givenName!+"")
            let familyName = user.profile.familyName
            print("User family name is "+familyName!+"")
            let email = user.profile.email
            print("User email address is "+email!+"")
            
            labelError.isHidden = false;
            labelError.text = "Profile : "+fullName!+""
            
            if(user.profile.hasImage){
                URLSession.shared.dataTask(with: NSURL(string: user.profile.imageURL(withDimension: 400).absoluteString)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.imageSocial.image = image
                    self.imageSocial.layer.borderWidth = 1
                    self.imageSocial.layer.masksToBounds = false
                    self.imageSocial.layer.borderColor = UIColor.clear.cgColor
                    self.imageSocial.layer.cornerRadius = self.imageSocial.frame.height/2
                    self.imageSocial.clipsToBounds = true
                })
                
            }).resume()
            }else{
                self.imageSocial.image = UIImage(named: "login.png")
            }
            
        } else {
            print("ERROR ::\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(user)
        labelError.isHidden = true;
        self.labelError.text = ""
        self.imageSocial.image = UIImage(named: "login.png")
        self.imageSocial.clipsToBounds = false
    }
    
    func onGoogleSuccessResponse(user: Any) {
        hideProgressIndicator()
        print(user)
        labelError.isHidden = false;
        //        labelError.text = "Failed : "+user+""
    }
    
    func onGoogleErrorResponse(error: Error?) {
        hideProgressIndicator()
        print(error?.localizedDescription as Any)
        labelError.isHidden = false;
        labelError.text = "Failed : "+(error?.localizedDescription)!+""
    }
}

