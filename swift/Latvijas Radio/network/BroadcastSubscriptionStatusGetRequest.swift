//
//  BroadcastSubscriptionStatusGetRequest.swift
//  Latvijas Radio
//
//  Created by Sandis Putnis on 13/12/2021.
//

import UIKit

class BroadcastSubscriptionStatusGetRequest {

    static let TAG = String(describing: BroadcastSubscriptionStatusGetRequest.self)
    
    static let RESPONSE_PARAM_SUBSCRIBED = "subscribed"

    weak var notificationViewController: NotificationViewController?
    
    var task: URLSessionDataTask!
    var successCallback: ((_ receivedData: [String: Any]) -> Void)?
    var errorCallback: (() -> (Void))?
    var restartRequestCallback: (() -> (Void))!

    init(_ notificationViewController: NotificationViewController, _ broadcastId: String) {
        self.notificationViewController = notificationViewController
        
        createQuery(broadcastId)

        restartRequestCallback = {
            self.createQuery(broadcastId)
            self.execute()
        }
    }
    
    func createQuery(_ broadcastId: String) {
        notificationViewController?.hideNotificationInstantly()
        
        let url = URL(string: Configuration.API_URL + "/broadcast/" + broadcastId + "/subscription-status")!
        
        GeneralUtils.log(BroadcastSubscriptionStatusGetRequest.TAG, url)
        
        let usersManager = UsersManager.getInstance()
        let accessToken = usersManager.getAccessTokenForRequests()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(GeneralUtils.getAppVersion(), forHTTPHeaderField: "App-Version-Ios")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession.init(configuration: config)

        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async(execute: {
                // check for network error
                guard let data = data, error == nil else {
                    let message = RequestManager.getMessageFromNetworkError(error)
                    self.notificationViewController?.showNotification(text: message.localized())

                    self.errorCallback?()
                    
                    return
                }

                // process API response
                let responseJson = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJson = responseJson as? [String: Any] {
                    
                    //GeneralUtils.log(BroadcastSubscriptionStatusGetRequest.TAG, String(data: data, encoding: .utf8)!)
                    
                    // check for error
                    let responseError = RequestManager.getErrorFromResponse(responseJson)
                    if (responseError != nil) {
                        RequestManager.handleResponseError(responseError!, self.notificationViewController, self.errorCallback, self.restartRequestCallback)
                    } else {
                        let data = responseJson[RequestManager.RESPONSE_PARAM_DATA] as! [String: Any]
                        
                        self.successCallback?(data)
                    }
                } else {
                    let message = RequestManager.getMessageFromNetworkError(error)
                    self.notificationViewController?.showNotification(text: message.localized())

                    self.errorCallback?()
                }
            })
        }
    }

    func execute() {
        task.resume()
    }
}
