//
//  LoginApi.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/08.
//

import Moya

public enum LoginAPI {
    case appleLogin(authCode: String)
    case googleLogin(accessToken: String)
}

extension LoginAPI: TargetType {
    static func errorStubbingProvider(
        endPointClosure: @escaping (LoginAPI) -> Endpoint
    ) -> MoyaProvider<LoginAPI> {
        return MoyaProvider<LoginAPI>(
            endpointClosure: endPointClosure,
            stubClosure: MoyaProvider.immediatelyStub
        )
    }
    
    public static var provider: MoyaProvider<LoginAPI> {
        return MoyaProvider<LoginAPI>()
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
        case .appleLogin:
            return "/apple-login"
        case .googleLogin:
            return "/google-login"
        }
    }
    
    public var method: Method {
        switch self {
        case .appleLogin:
            return .post
        case .googleLogin:
            return .post
        }
    }
    
    public var sampleData: Data {
        return stubData(self)
    }
    
    public var task: Task {
        switch self {
        case .appleLogin(let authCode):
            return .requestParameters(
                parameters: ["code": authCode],
                encoding: JSONEncoding.default
            )
        case .googleLogin(let accessToken):
            return .requestParameters(
                parameters: ["access_token": accessToken],
                encoding: JSONEncoding.default
            )
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

public extension LoginAPI {
    func stubData(_ loginAPI: LoginAPI) -> Data {
        switch self {
        case .appleLogin:
            return Data(
                """
                {
                    "isSuccess": true,
                    "code": 1000,
                    "message": "Apple Login 성공",
                    "result": {
                        "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoxLCJpYXQiOjE2MTQ4NzUzMzMsImV4cCI6MTY0NjQxMTMzMywic3ViIjoidXNlckluZm8ifQ.HkuZDB696zKdRWsn-o1DsBNTnnbtADmaxGpXpFEJtss",
                        "userIdx": 2,
                        "member": "회원"
                    }
                }
                """.utf8
            )
        case .googleLogin:
            return Data(
                """
                {
                    "isSuccess": true,
                    "code": 1000,
                    "message": "구글 로그인 성공",
                    "result": {
                        "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoxLCJpYXQiOjE2MTQ5NDI0MTUsImV4cCI6MTY0NjQ3ODQxNSwic3ViIjoidXNlckluZm8ifQ.aTpzNPVfwfnessZM9kDWkzrZzs7KfrogHtTA9Nig5ts",
                        "userIdx": 1,
                        "member": "회원"
                    }
                }
                """.utf8
            )
        }
    }
}
