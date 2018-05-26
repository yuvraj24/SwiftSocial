//
//  ResponseDelegate.swift
//  swiftconcepts
//
//  Created by new on 25/05/18.
//  Copyright © 2018 yuvraj. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol ResponseDelegate {
    func onApiResponse(user : AuthDataResult)
    func onErrorResponse(error : Error?)
}
