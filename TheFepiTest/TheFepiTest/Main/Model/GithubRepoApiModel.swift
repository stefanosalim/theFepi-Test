//
//  GithubRepoApiModel.swift
//  TheFepiTest
//
//  Created by stefano.salim on 19/07/21.
//

import Foundation

struct GithubRepoSpec {
    
    var query: String
    var page: Int
    var perPage: Int
}

struct GithubRepoResponse: Decodable {
    var items: [GithubRepoItem]
}

struct GithubRepoItem: Decodable {
    
    var name: String
    var createdAt: String
    var watchers: Int
    var forks: Int
    var stars: Int
    
    enum DefaultIssueKeys: String, CodingKey {
        case name, watchers, forks, createdAt = "created_at", stars = "stargazers_count"
    }
    
    init(from decoder: Decoder) throws {
        let defaultValues = try decoder.container(keyedBy: DefaultIssueKeys.self)
        name = try defaultValues.decode(String.self, forKey: .name)
        createdAt = try defaultValues.decode(String.self, forKey: .createdAt)
        stars = try defaultValues.decode(Int.self, forKey: .stars)
        watchers = try defaultValues.decode(Int.self, forKey: .watchers)
        forks = try defaultValues.decode(Int.self, forKey: .forks)
    }
}
