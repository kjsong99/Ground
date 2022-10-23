//
//  NotesModel.swift
//  Move
//
//  Created by 송경진 on 2022/10/20.
//

import Foundation

struct NotesResponseElement: Codable {
    let id: Int
    let title, content: String
    let send_user, receive_user: PostUser?
    let read: Int
    let created_at, updated_at: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case send_user, receive_user
        case read
        case created_at
        case updated_at
    }
}

typealias NotesResponse = [NotesResponseElement]

extension NotesResponse {
    func sort() -> NotesResponse{
        return self.sorted(by: {$0.created_at < $1.created_at})
    }
    
}

func append(data1 : NotesResponse, data2 : NotesResponse) -> NotesResponse{
    var result : NotesResponse = NotesResponse()
    result += data1
    for data in data2{
        for temp in result{
            if data.send_user!.id == temp.receive_user!.id {
                break
            }
            result.append(data)
        }
    }
    return result
}
