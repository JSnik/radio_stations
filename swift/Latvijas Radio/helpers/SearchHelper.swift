//
//  SearchHelper.swift
//  Latvijas Radio
//
//  Created by andriy kruglyanko on 07.12.2024.
//  Copyright © 2024 Latvijas Radio. All rights reserved.
//

import Foundation

class SearchHelper {

    //GenericPreviewModel

    static func getSearchItemListFromJsonArray(_ searchItems: [[String: Any]]) -> [SearchItem] {
        var dataset = [SearchItem]()

        for searchItemJson in searchItems {
            let searchItemModel = getSearchItemFromJsonObject(searchItemJson)
            if (searchItemModel != nil) {
                dataset.append(searchItemModel!)
            }
        }

        return dataset
    }

    static func getSearchItemFromJsonObject(_ searchItemJson: [String: Any]) -> SearchItem? {
        var searchItemModel: SearchItem? = nil

        // Since many endpoints return EpisodeJsonObjectModel,
        // we keep the field names here.

        // Some episodes from client API might not have any audio (comes as empty array), skip them.
        let media = searchItemJson["media"] as? [String: Any]
        if (media != nil) {
            let id = searchItemJson["id"] as! Int
//            searchItemModel = SearchItem.init(id: id, title: "", showName: "", imageURL: "")
            var imageUrl = ""
            if let images = searchItemJson["images"] as? Dictionary<String,String> ,
               let imLarge = images["large"] {
                imageUrl = imLarge
            } else {
                if let imageUrl1 = searchItemJson["imageUrl"] as? String {
                    imageUrl = imageUrl1
                }
            }

            //let imageUrl = searchItemJson["imageUrl"] as! String
            let title = searchItemJson["title"] as! String
//            if let description = searchItemJson["description"] as? String {
//                searchItemModel?.setDescription(description)
//            } else {
//                if let leadHtml = searchItemJson["lead"] {
//                    let strHtml = (leadHtml as AnyObject).debugDescription.replacingOccurrences(of: "<[^>]+>", with: "")
//                    searchItemModel?.setDescription(strHtml)
//                }
//            }

            var categoryName = title
            var categoryTitle = ""
            var  categoryId = 0 //searchItemJson["categoryId"] as! Int
            var channelId = "1"
            var categoryImageUrl = ""
            var hosts = [String]()
            var email = ""
            if let category = searchItemJson["category"] as? Dictionary<String,Any>,
               let ktit = category["id"] as? Int64 {
                categoryId = Int(ktit)
                if let categoryName1 = category["title"] as? String {
                    categoryName = categoryName1
                }
                if let categoryTitle1 = category["descr"] as? String {
                    categoryTitle = categoryTitle1
                }
                categoryTitle.replacingOccurrences(of: "<p>", with: "")
                categoryTitle.replacingOccurrences(of: "</p>", with: "")
                if let channelId1 = category["channel"] as? String {
                    channelId = channelId1
                }
                if let categoryImageUrl1 = category["logo"] as? String {
                    categoryImageUrl = categoryImageUrl1
                }
                if let email1 = category["email"] as? String {
                    email = email1
                }
                if let hosts1 = category["hosts"] as? [NSDictionary] {
                    var result = [String]()
                    do {
                        for el in hosts1 {
                            let hostAsJsonString: String? = try el.toString()
                            if (hostAsJsonString != nil) {
                                result.append(hostAsJsonString!)
                            }
                        }
                    } catch(let error){
                        GeneralUtils.log(EpisodeModel.TAG, error.localizedDescription)
                    }
                    hosts = result
                }
            } else {
                categoryId = searchItemJson["categoryId"] as! Int
            }
            var aired: UInt64 = 0
            if let aired1: UInt64 = searchItemJson["aired"] as? UInt64 {
                let published: UInt64 = searchItemJson["published"] as! UInt64
                aired = aired > 0 ? aired * 1000 : published * 1000
            }


            let audio = media!["audio"] as! [[String: Any]]
            let audioItem = audio[0]
            let mediaDuration = audioItem["duration"] as! Int

            let audioData = audioItem["data"] as! [String: Any]
            let links = audioData["links"] as! [String: Any]
            let mp3 = links["mp3"] as! [String: Any]

            let mediaDownloadUrl = mp3["download"] as? String

            let mediaStreamUrl = mp3["html5"] as! String
            let url = searchItemJson["url"] as? String

            var newsBlocks = [String]() //[NSDictionary]()
            if let newsBlocks1 = searchItemJson["newsBlocks"] as? [NSDictionary] {
                var result = [String]()
                do {
                    for el in newsBlocks1 {
                        let newsBlocksAsJsonString: String? = try el.toString()
                        if (newsBlocksAsJsonString != nil) {
                            result.append(newsBlocksAsJsonString!)
                        }
                    }
                } catch(let error){
                    GeneralUtils.log(EpisodeModel.TAG, error.localizedDescription)
                }
                newsBlocks = result
            }

            var lsmTags = [String]() //[NSDictionary]()
            if let lsmTags1 = searchItemJson["lsm_tags"] as? [NSDictionary] {
                var result = [String]()
                do {
                    for el in lsmTags1 {
                        let lsmTagsAsJsonString: String? = try el.toString()
                        if (lsmTagsAsJsonString != nil) {
                            result.append(lsmTagsAsJsonString!)
                        }
                    }
                } catch(let error){
                    GeneralUtils.log(EpisodeModel.TAG, error.localizedDescription)
                }
                lsmTags = result
            }

            var category = CategoryItem(id: categoryId, title: categoryName, descr: categoryTitle, channel: channelId, email: email, hosts: hosts, imageURL: categoryImageUrl)
            //            searchItemModel = GenericPreviewModel(String(id))

            searchItemModel = SearchItem(id: id, title: title, imageURL: imageUrl, dateInMillis: Double(aired), mediaDurationInSeconds: mediaDuration, mediaStreamUrl: mediaStreamUrl, newsBlocks: newsBlocks, lsmTags: lsmTags, category: category)
        }

        return searchItemModel
    }

    static func getSearchItemFromJsonObject1(_ searchItemJson: [String: Any]) -> SearchItem? {
        var searchItemModel: SearchItem? = nil

        // Since many endpoints return EpisodeJsonObjectModel,
        // we keep the field names here.

        // Some episodes from client API might not have any audio (comes as empty array), skip them.
        let media = searchItemJson["document"] as? [String: Any]
        if (media != nil) {
            let id = media?["id"] as! Int
//            searchItemModel = SearchItem.init(id: id, title: "", showName: "", imageURL: "")
            let show_id = media?["show_id"] as! Int
            let show_name = media?["show_name"] as! Int
            let type = media?["type"]
            var imageUrl = ""
            if let imageUrl1 = media?["image"] as? String {
                imageUrl = imageUrl1
            }

            //let imageUrl = searchItemJson["imageUrl"] as! String
            let title = media?["title"] as! String
//            if let description = searchItemJson["description"] as? String {
//                searchItemModel?.setDescription(description)
//            } else {
//                if let leadHtml = searchItemJson["lead"] {
//                    let strHtml = (leadHtml as AnyObject).debugDescription.replacingOccurrences(of: "<[^>]+>", with: "")
//                    searchItemModel?.setDescription(strHtml)
//                }
//            }

            var categoryName = title
            var categoryTitle = ""
            var  categoryId = 0 //searchItemJson["categoryId"] as! Int
            var channelId = "1"
            var categoryImageUrl = ""
            var hosts = [String]()
            var email = ""
            if let category = searchItemJson["category"] as? Dictionary<String,Any>,
               let ktit = category["id"] as? Int64 {
                categoryId = Int(ktit)
                if let categoryName1 = category["title"] as? String {
                    categoryName = categoryName1
                }
                if let categoryTitle1 = category["descr"] as? String {
                    categoryTitle = categoryTitle1
                }
                categoryTitle.replacingOccurrences(of: "<p>", with: "")
                categoryTitle.replacingOccurrences(of: "</p>", with: "")
                if let channelId1 = category["channel"] as? String {
                    channelId = channelId1
                }
                if let categoryImageUrl1 = category["logo"] as? String {
                    categoryImageUrl = categoryImageUrl1
                }
                if let email1 = category["email"] as? String {
                    email = email1
                }
                if let hosts1 = category["hosts"] as? [NSDictionary] {
                    var result = [String]()
                    do {
                        for el in hosts1 {
                            let hostAsJsonString: String? = try el.toString()
                            if (hostAsJsonString != nil) {
                                result.append(hostAsJsonString!)
                            }
                        }
                    } catch(let error){
                        GeneralUtils.log(EpisodeModel.TAG, error.localizedDescription)
                    }
                    hosts = result
                }
            } else {
                categoryId = searchItemJson["categoryId"] as! Int
            }
            var aired: UInt64 = 0
            if let aired1: UInt64 = searchItemJson["aired"] as? UInt64 {
                let published: UInt64 = searchItemJson["published"] as! UInt64
                aired = aired > 0 ? aired * 1000 : published * 1000
            }


            let audio = media!["audio"] as! [[String: Any]]
            let audioItem = audio[0]
            let mediaDuration = audioItem["duration"] as! Int

            let audioData = audioItem["data"] as! [String: Any]
            let links = audioData["links"] as! [String: Any]
            let mp3 = links["mp3"] as! [String: Any]

            let mediaDownloadUrl = mp3["download"] as? String

            let mediaStreamUrl = mp3["html5"] as! String
            let url = searchItemJson["url"] as? String

            var newsBlocks = [String]() //[NSDictionary]()
            if let newsBlocks1 = searchItemJson["newsBlocks"] as? [NSDictionary] {
                var result = [String]()
                do {
                    for el in newsBlocks1 {
                        let newsBlocksAsJsonString: String? = try el.toString()
                        if (newsBlocksAsJsonString != nil) {
                            result.append(newsBlocksAsJsonString!)
                        }
                    }
                } catch(let error){
                    GeneralUtils.log(EpisodeModel.TAG, error.localizedDescription)
                }
                newsBlocks = result
            }

            var lsmTags = [String]() //[NSDictionary]()
            if let lsmTags1 = searchItemJson["lsm_tags"] as? [NSDictionary] {
                var result = [String]()
                do {
                    for el in lsmTags1 {
                        let lsmTagsAsJsonString: String? = try el.toString()
                        if (lsmTagsAsJsonString != nil) {
                            result.append(lsmTagsAsJsonString!)
                        }
                    }
                } catch(let error){
                    GeneralUtils.log(EpisodeModel.TAG, error.localizedDescription)
                }
                lsmTags = result
            }

            var category = CategoryItem(id: categoryId, title: categoryName, descr: categoryTitle, channel: channelId, email: email, hosts: hosts, imageURL: categoryImageUrl)
            //            searchItemModel = GenericPreviewModel(String(id))

            searchItemModel = SearchItem(id: id, title: title, imageURL: imageUrl, dateInMillis: Double(aired), mediaDurationInSeconds: mediaDuration, mediaStreamUrl: mediaStreamUrl, newsBlocks: newsBlocks, lsmTags: lsmTags, category: category)
        }

        return searchItemModel
    }

}

