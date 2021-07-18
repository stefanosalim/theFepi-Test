//
//  GithubIssueSpec.swift
//  TheFepiTest
//
//  Created by stefano.salim on 19/07/21.
//

import Foundation

struct GithubIssueSpec {
    
    var query: String
    var page: Int
    var perPage: Int
}

struct GithubIsseResponse: Decodable {
    var items: [GithubIssueItem]
}

struct GithubIssueItem: Decodable {
    
    var title: String
    var updatedAt: String
    var state: String
    
    enum DefaultIssueKeys: String, CodingKey {
        case title, state, updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let defaultValues = try decoder.container(keyedBy: DefaultIssueKeys.self)
        title = try defaultValues.decode(String.self, forKey: .title)
        state = try defaultValues.decode(String.self, forKey: .state)
        updatedAt = try defaultValues.decode(String.self, forKey: .updatedAt)
    }
}
