//  LinkMoaAPI.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/05/13.
//

import Moya

public enum LinkMoaAPI {
    // MARK: - folder
    case folderDetail(index: Int)
    case myFolderList(index: Int, filter: Int)
    case addFolder(params: [String: Any])
    case editFolder(index: Int, params: [String: Any])
    case deleteFolder(index: Int)
    case addLink(index: Int, params: [String: Any])
    case editLink(index: Int, params: [String: Any])
    case deleteLink(index: Int)
    case editUserInformation(params: [String: Any])
    // MARK: - surfing
    case like(index: Int)
    case topTenFolder
    case likedFolder(params: [String: Any])
    case usersFolder(index: Int, params: [String: Any])
    case categoryDetail(mainIndex: Int, subIndex: Int, params: [String: Any])
    case searchFolder(params: [String: Any])
    case searchLink(params: [String: Any])
    case report(params: [String: Any])
    case categories
    case userInformation
    case deleteAccount(index: Int)
    case todayFolder
}

extension LinkMoaAPI: TargetType {
    static func errorStubbingProvider(
        endPointClosure: @escaping (LinkMoaAPI) -> Endpoint
    ) -> MoyaProvider<LinkMoaAPI> {
        return MoyaProvider<LinkMoaAPI>(
            endpointClosure: endPointClosure,
            stubClosure: MoyaProvider.immediatelyStub
        )
    }
    
    public static var provider: MoyaProvider<LinkMoaAPI> {
        return MoyaProvider<LinkMoaAPI>()
    }
    
    public var baseURL: URL {
        switch PrivateKey.serviceType {
        case .dev:
            guard let url = URL(string: PrivateKey.devServerDomatinURL) else { fatalError() }
            return url
        case .product:
            guard let url = URL(string: PrivateKey.productServerDomainURL) else { fatalError() }
            return url
        }
    }
    
    public var path: String {
        switch self {
        case .folderDetail(let index):
            return "/folders/\(index)"
        case .myFolderList:
            return "/users/folders"
        case .addFolder:
            return "/folders"
        case .editFolder(let index, _):
            return "/folders/\(index)"
        case .deleteFolder(let index):
            return "/folders/\(index)/status"
        case .addLink(let index, _):
            return "/folders/\(index)/link"
        case .editLink(let index, _):
            return "/links/\(index)"
        case .deleteLink(let index):
            return "/links/\(index)/status"
        case .editUserInformation:
            return "/users"
        case .like(let index):
            return "/folders/\(index)/like"
        case .topTenFolder:
            return "/folders/top"
        case .likedFolder:
            return "/users/like"
        case .usersFolder(let index, _):
            return "/users/\(index)/folders"
        case .categoryDetail(let main, let sub, _):
            return "/categories/\(main)/detailCategories/\(sub)/folders"
        case .searchFolder:
            return "/folders/search"
        case .searchLink:
            return "/links/search"
        case .report:
            return "/reports"
        case .categories:
            return "/categories"
        case .userInformation:
            return "/users"
        case .deleteAccount(let index):
            return "/users/\(index)/status"
        case .todayFolder:
            return "/folders/today"
        }
    }
    
    public var method: Method {
        switch self {
        case .myFolderList,
             .folderDetail,
             .topTenFolder,
             .likedFolder,
             .usersFolder,
             .categoryDetail,
             .searchFolder,
             .searchLink,
             .categories,
             .userInformation,
             .todayFolder:
            return .get
        case .addFolder,
             .addLink,
             .like,
             .report:
            return .post
        case .editFolder,
             .editLink,
             .deleteFolder,
             .deleteLink,
             .editUserInformation,
             .deleteAccount:
            return .patch
        }
    }
    
    public var sampleData: Data {
        return stubData(self)
    }
    
    public var task: Task {
        switch self {
        case .deleteFolder,
             .deleteLink,
             .folderDetail,
             .like,
             .topTenFolder,
             .categories,
             .userInformation,
             .deleteAccount,
             .todayFolder:
            return .requestPlain
            
        case .usersFolder(_, let params),
             .categoryDetail(_, _, let params),
             .searchFolder(let params),
             .likedFolder(let params),
             .searchLink(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .myFolderList(_, let filter):
            let param: [String: Any] = ["page": "0", "limit": "200", "filter": filter]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        
        case .addFolder(let params),
             .editFolder(_, let params),
             .addLink(_, let params),
             .editLink(_, let params),
             .editUserInformation(let params),
             .report(params: let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        guard let jwtToken = TokenManager().jwt else { return nil }
        return ["Content-Type": "application/json", "x-access-token": jwtToken]
    }
}
