//
//  EpisodeSearchRequest.swift
//  Latvijas Radio
//
//  Created by andriy kruglyanko on 17.12.2024.
//  Copyright © 2024 Latvijas Radio. All rights reserved.
//

import UIKit

class EpisodeSearchRequest {

    static let TAG = String(describing: EpisodeSearchRequest.self)

    weak var notificationViewController: NotificationViewController?

    var task: URLSessionDataTask!
    var successCallback: ((_ receivedData: [String: Any], _ data1: Data) -> Void)?
    var errorCallback: (() -> (Void))?
    var restartRequestCallback: (() -> (Void))!
    var errorMessage: String?

    init( _ urlPathParams: [URLQueryItem]) {

        createQuery(urlPathParams)

        restartRequestCallback = {
            self.createQuery(urlPathParams)
            self.execute()
        }
    }

    func createQuery(_ urlQueryItems: [URLQueryItem]) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.latvijasradio.lsm.lv" //Configuration.API_URL_SEARCH
        components.path =  "/api/" // "/collections/lrapp/documents/search"
        components.queryItems = urlQueryItems

        if let url = URL(string: components.string ?? Configuration.API_URL_SEARCH) {
            GeneralUtils.log(EpisodeSearchRequest.TAG, url)
            GeneralUtils.log(EpisodeSearchRequest.TAG, urlQueryItems)
            var request = URLRequest(url: (url))
            request.httpMethod = "GET"
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData //.returnCacheDataElseLoad //.reloadIgnoringLocalCacheData
//            config.urlCache = nil

            let session = URLSession.init(configuration: config)
            task = session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async(execute: {
                    // check for network error
                    guard let data = data, error == nil else {
                        let message = RequestManager.getMessageFromNetworkError(error)
                        self.notificationViewController?.showNotification(text: message.localized())

                        self.errorMessage = message
                        self.errorCallback?()

                        return
                    }

                    // process API response
                    let responseJson = try? JSONSerialization.jsonObject(with: data, options: [])
//                    let searchSuccess = try? JSONDecoder().decode(SearchSuccess.self, from: data)
//                    print("searchSuccess = \(searchSuccess)")
//                    print("responseJson = \(responseJson)")
                    if let responseJson = responseJson as? [String: Any] {

                        //GeneralUtils.log(BroadcastByCategoryRequest.TAG, String(data: data, encoding: .utf8)!)

                        // check for error
                        let responseError = RequestManager.getErrorFromResponse(responseJson)
                        if (responseError != nil) {
                            self.errorMessage = responseError

                            RequestManager.handleResponseError(responseError!, self.notificationViewController, self.errorCallback, self.restartRequestCallback)
                        } else {
//                            let data = responseJson

                            self.successCallback?(responseJson, data)
                        }
                    } else {
                        let message = RequestManager.getMessageFromNetworkError(error)
                        self.notificationViewController?.showNotification(text: message.localized())

                        self.errorMessage = message
                        self.errorCallback?()
                    }
                })
            }
        }
    }

    func execute() {
        task.resume()
    }
}
