//
//  ErrorMessage.swift
//  Move
//
//  Created by 송경진 on 2022/09/30.
//

import Foundation


enum ErrorMessage: Error {
    case outOfRange(from: Int)
    case notInt
    case typeError
}
