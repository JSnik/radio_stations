//
//  SearchItem.swift
//  Latvijas Radio
//
//  Created by andriy kruglyanko on 07.12.2024.
//  Copyright © 2024 Latvijas Radio. All rights reserved.
//

import Foundation

struct SearchItem: Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, category, mediaDurationInSeconds, mediaStreamUrl
        case dateInMillis =  "aired"
        case imageURL = "image"
        case lsmTags = "lsm_tags"
        case newsBlocks = "newsblocks"
    }

    var id: Int
    var title: String
    var dateInMillis: Double
    var imageURL: String?
    var lsmTags: [String]?
    var newsBlocks: [String]?
    var mediaDurationInSeconds: Int
    var mediaStreamUrl: String
    var category: CategoryItem?

    init(
        id: Int,
        title: String,
        imageURL: String,
        dateInMillis: Double,
        mediaDurationInSeconds: Int,
        mediaStreamUrl: String,
        newsBlocks: [String]?,
        lsmTags: [String]?,
        category: CategoryItem
    ) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.category = category
        self.mediaDurationInSeconds = mediaDurationInSeconds
        self.mediaStreamUrl = mediaStreamUrl
        self.newsBlocks = newsBlocks
        self.lsmTags = lsmTags
        self.dateInMillis = dateInMillis
    }

}

struct CategoryItem: Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, descr, channel, hosts, email
        case imageURL = "logo"
    }

    var id: Int
    var title: String
    var descr: String
    var channel: String
    var email: String
    var hosts: [String]?
    var imageURL: String?

    init(
        id: Int,
        title: String,
        descr: String,
        channel: String,
        email: String,
        hosts: [String]?,
        imageURL: String
    ) {
        self.id = id
        self.title = title
        self.descr = descr
        self.channel = channel
        self.email = email
        self.imageURL = imageURL
        self.hosts = hosts
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
//        descr = try values.decodeIfPresent(String.self, forKey: .descr) ?? ""
//        channel = try values.decodeIfPresent(String.self, forKey: .channel) ?? ""
//        hosts = try values.decodeIfPresent([Host].self, forKey: .hosts)
//        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
//    }
}
