//
//  SignupViewController.swift
//  swiftconcepts
//
//  Created by new on 21/05/18.
//  Copyright © 2018 yuvraj. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: BaseViewController, ResponseDelegate {
    
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var labelError: UILabel!
    let fireAuth : FirebaseAuthenticator = FirebaseAuthenticator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelError.isHidden = true;
        fireAuth.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createUserOnFirebase(_ sender: Any) {
        
        let userName = textFieldUserName.text!
        let passWord = textFieldPassword.text!
        
        if(fireAuth.validateFields(username: userName , password: passWord, labelError: self.labelError)){
            showProgressIndicator()
            labelError.isHidden = true;
            fireAuth.firebaseSignUp(email: userName,password: passWord)
        } 
    }
    
    func onApiResponse(user: AuthDataResult) {
        hideProgressIndicator()
        print(user)
        labelError.text = "Signup Successful : "+user.user.email!+""
    }
    
    func onErrorResponse(error: Error?) {
        hideProgressIndicator()
        print(error!.localizedDescription)
        labelError.isHidden = false;
        labelError.text = "Failed : "+error!.localizedDescription+""
    }
    
}
