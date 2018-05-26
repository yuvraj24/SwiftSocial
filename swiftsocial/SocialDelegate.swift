//
//  SocialDelegate.swift
//  swiftconcepts
//
//  Created by new on 25/05/18.
//  Copyright © 2018 yuvraj. All rights reserved.
//

import Foundation

protocol SocialDelegate {
    func onFBSuccessResponse(user : Any)
    func onFBErrorResponse(error : Error?)
    
    func onGoogleSuccessResponse(user : Any)
    func onGoogleErrorResponse(error : Error?)
}
