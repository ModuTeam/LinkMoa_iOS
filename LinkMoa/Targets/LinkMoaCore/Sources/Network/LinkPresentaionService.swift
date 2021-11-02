//
//  LinkPresentaionService.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/19.
//

import LinkPresentation
import UIKit

import Alamofire
import Kanna
import RxSwift

public enum LinkError: Error {
    case urlInvalid
    case metadata
}

public struct LinkPresentaionService {
    static let googleFaviconURLString = "https://www.google.com/s2/favicons?sz=64&domain_url="
    
    private let urlSession: URLSession
    private var metadataProvider: LPMetadataProviderProtocol
    
    public init(
        urlSession: URLSession = .shared,
        metadataProvider: LPMetadataProviderProtocol
    ) {
        self.urlSession = urlSession
        self.metadataProvider = metadataProvider
        self.metadataProvider.timeout = 5
    }
    
    // 타이틀 가져오는 메서드 ( share extension 에서만 사용 )
    public func fetchTitle(urlString: String, completionHandler: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completionHandler(nil)
            return
        }
        
        metadataProvider.startFetchingMetadata(for: url, completionHandler: { metadata, error in
            if let _ = error {
                completionHandler(nil)
                return
            }
            
            completionHandler(metadata?.title)
        })
    }
    
    // completionHandler: (타이틀, 웹 이미지 URL, 파비콘 URL)
    func fetchMetaDataURL(
        targetURLString URLString: String,
        completionHandler: @escaping (WebMetaData) -> Void
    ) {
        guard let url = URL(string: URLString) else { return }
        
        var title: String?
        var image: String?
        let favicon = LinkPresentaionService.googleFaviconURLString + URLString
        
        let dataTask = urlSession.dataTask(with: url) { data, _, error in
            if let _ = error {
                completionHandler(WebMetaData())
                return
            }
            
            if let data = data,
               let htmlString = String(data: data, encoding: .utf8) {
                do {
                    let doc = try HTML(html: htmlString, encoding: .utf8)

                    for link in doc.xpath("//meta[@property='og:title']") {
                        if let contentTitle = link["content"] {
                            title = contentTitle
                            break
                        }
                    }
                    
                    for link in doc.xpath("//meta[@property='og:image']") {
                        if let imageURLString = link["content"] {
                            image = imageURLString
                            break
                        }
                    }
                    
                    completionHandler(
                        WebMetaData(
                            title: title,
                            webPreviewURLString: image,
                            faviconURLString: favicon
                        )
                    )
                    return
                } catch {
                    completionHandler(WebMetaData())
                    return
                }
            }
            
            completionHandler(WebMetaData())
            return
        }
        
        dataTask.resume()
    }
}

// MARK: RX로 구현
extension LinkPresentaionService {
    public func fetchTitle(urlString: String) -> Single<String> {
        return Single.create(subscribe: { observer -> Disposable in
            fetchTitle(urlString: urlString) { title in
                observer(.success(title ?? ""))
            }
            return Disposables.create()
        })
    }
    
    public func fetchMetaDataURL(targetURLString urlString: String) -> Single<WebMetaData> {
        return Single.create(subscribe: { observer -> Disposable in
            fetchMetaDataURL(targetURLString: urlString) { metadata in
                observer(.success(metadata))
            }
            return Disposables.create()
        })
    }
}
