//
//  ErrorsCatch.swift
//  20240118-NaveenChatla-NYCSchools
//
//  Created by Mac on 19/01/24.
//

import Foundation

//MARK:- HTTP Errors
enum Errors: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}
