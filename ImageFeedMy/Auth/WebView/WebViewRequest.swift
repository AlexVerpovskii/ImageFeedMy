//
//  WebViewRequest.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 30.06.2024.
//

import Foundation

final class WebViewRequest: BaseRequestImpl {
    override var endPoint: String { Constants.Unsplash.pathAuthorize }
    override var parameters: [String : String] {
        return [
            Constants.Unsplash.QueryItem.clientId : Constants.Unsplash.accessKey,
            Constants.Unsplash.QueryItem.redirectUri : Constants.Unsplash.redirectUri,
            Constants.Unsplash.QueryItem.responseType : Constants.Unsplash.code,
            Constants.Unsplash.QueryItem.scope : Constants.Unsplash.accessScope
        ]}
}
