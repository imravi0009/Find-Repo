//
//  RepositoryModel.swift
//  Find Repo
//
//  Created by Ravi Kumar on 30/11/21.
//

import Foundation

// MARK: - RepositoryResponse
struct RepositoryResponse: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    let node_id, name, full_name: String
    let owner: Owner
    let html_url: String
    let description: String
    let fork: Bool
    let url, forks_url: String
    let keys_url, collaborators_url: String
    let teams_url, hooks_url: String
    let issue_events_url: String
    let events_url: String
    let assignees_url, branches_url: String
    let tags_url: String
    let blobs_url, git_tags_url, git_refs_url, trees_url: String
    let statuses_url: String
    let languages_url, stargazers_url, contributors_url, subscribers_url: String
    let subscription_url: String
    let commits_url, git_commits_url, comments_url, issue_comment_url: String
    let contents_url, compare_url: String
    let merges_url: String
    let archive_url: String
    let downloads_url: String
    let language: String?
    let has_pages: Bool
    let forks_count: Int
    let open_issues_count: Int
    let license: License?
    let allow_forking, is_template: Bool
    let topics: [String]
     let visibility: Visibility
    let forks, open_issues, watchers: Int
      let score: Int
}

enum DefaultBranch: String, Codable {
    case alpha = "alpha"
    case ghPages = "gh-pages"
    case main = "main"
    case master = "master"
}

// MARK: - License
struct License: Codable {
    let key, name, spdx_id: String
    let url: String?
    let node_id: String
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url, html_url, followers_url: String
    let following_url, gists_url, starred_url: String
    let subscriptions_url, organizations_url, repos_url: String
    let events_url, received_events_url: String
    let type: TypeEnum
    let site_admin: Bool
}

enum TypeEnum: String, Codable {
    case organization = "Organization"
    case user = "User"
}

enum Visibility: String, Codable {
    case visibilityPublic = "public"
}
