//
//  HeartsModel.swift
//  Move
//
//  Created by 송경진 on 2022/10/05.
//

import Foundation

struct HeartsResponseElement : Codable{
    let id: Int
    let post : PostsResponseElement
    let user : UserResponseElement
    let created_at, updated_at: String
}

typealias HeartsResponse = [HeartsResponseElement]
