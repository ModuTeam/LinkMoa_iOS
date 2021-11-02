//
//  LinkMoaAPI+stubData.swift
//  LinkMoaCore
//
//  Created by won heo on 2021/09/23.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import Foundation
import LinkMoaKit

public extension LinkMoaAPI {
    func stubData(_ linkMoaAPI: LinkMoaAPI) -> Data {
        switch self {
        case .folderDetail(let index):
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "message": "폴더 상세조회 성공",
                  "result": {
                    "userIdx": 1,
                    "userNickname": "Casey",
                    "userProfileImgUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                    "folderIdx": \(index),
                    "folderName": "스택",
                    "folderType": "public",
                    "categoryIdx": 1,
                    "categoryName": "개발",
                    "detailCategoryIdx": 5,
                    "detailCategoryName": "자료구조/알고리즘",
                    "folderLikeCount": 2,
                    "folderLinkCount": 0,
                    "folderUpdatedAt": "1주전",
                    "likeStatus": 1,
                    "hashTagList": [],
                    "linkList": []
                  }
                }
                """.utf8
            )
            
        case .myFolderList:
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "message": "폴더 조회(나의 가리비) 성공",
                  "result": [
                    {
                      "folderIdx": 2,
                      "folderName": "Javascript👍",
                      "categoryName": "개발",
                      "detailCategoryName": "웹",
                      "folderType": "public",
                      "folderLinkCount": 2,
                      "linkImageUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                      "createdAt": "1주전",
                      "updatedAt": "50초전"
                    },
                    {
                      "folderIdx": 54,
                      "folderName": "iOS 개발 기초",
                      "categoryName": "개발",
                      "detailCategoryName": "-1",
                      "folderType": "private",
                      "folderLinkCount": 1,
                      "linkImageUrl": "https://imgnews.pstatic.net/image/003/2021/03/15/NISI20180322_0013922116_web_20180322145253_20210315162833869.jpg",
                      "createdAt": "8시간전",
                      "updatedAt": "46분전"
                    }
                  ]
                }
                """.utf8
            )
            
        case .addFolder(let params):
            func addFolderStub(params: [String: Any]) -> String? {
                guard let name = params["folderName"] as? String,
                      let type = params["folderType"] as? String
                else {
                    return nil
                }
                
                let tags = params["hashTagList"] as? [String]
                let category = params["categoryIdx"] as? Int
                let detailCategory = params["detailCategoryIdx"] as? Int
                
                // 2000 -> folderName을 입력하세요.
                if name.isEmpty {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2000,
                               "message": "folderName을 입력하세요."
                           }
                           """
                }
                
                // 2001 -> folderName은 30자 이하 문자열입니다.
                if name.count > 30 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2001,
                               "message": "folderName은 30자 이하 문자열입니다."
                           }
                           """
                }
                
                // 2002 -> hashTag는 20자 이하 문자열입니다.
                if let tags = tags,
                   tags.filter({ $0.count > 20 }).count > 0 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2002,
                               "message": "hashTag는 20자 이하 문자열입니다."
                           }
                           """
                }
                
                // 2003 -> folderType을 입력하세요.
                if type.isEmpty {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2003,
                               "message": "folderType을 입력하세요."
                           }
                           """
                }
                
                // 2004 -> folderType은 public 아니면 private입니다.
                if type != "private" && type != "public" {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2004,
                               "message": "folderType은 public 아니면 private입니다."
                           }
                           """
                }
                
                // 2005 -> categoryIdx을 입력하세요.
                if type == "public", category == nil {
                    return """
                           {
                             "isSuccess": false,
                             "code": 2005,
                             "message": "categoryIdx을 입력하세요."
                           }
                           """
                }
                
                // 2006 -> categoryIdx는 1-5 사이의 정수입니다.
                if let category = category,
                   category < 1 || category > 5 {
                    return  """
                            {
                                "isSuccess": false,
                                "code": 2006,
                                "message": "categoryIdx는 1-5 사이의 정수입니다."
                            }
                            """
                }
                
                // 2007 -> detailCategoryIdx를 입력하세요.
                if type == "public", detailCategory == nil {
                    return  """
                            {
                                "isSuccess": false,
                                "code": 2007,
                                "message": "detailCategoryIdx를 입력하세요."
                            }
                            """
                }
                
                // 2008 -> detailCategoryIdx는 1-30 사이의 정수입니다.
                if let detailCategory = detailCategory,
                   detailCategory < 1 || detailCategory > 30 {
                    return  """
                            {
                                "isSuccess": false,
                                "code": 2008,
                                "message": "detailCategoryIdx는 1-30 사이의 정수입니다."
                            }
                            """
                }
                
                // 1000 -> 폴더 생성 성공
                return """
                       {
                           "folderIdx": 21,
                           "isSuccess": true,
                           "code": 1000,
                           "message": "폴더 생성 성공"
                       }
                       """
            }
            return Data((addFolderStub(params: params) ?? "").utf8)
            
        case .editFolder(_, let params):
            func editFolderStub(params: [String: Any]) -> String? {
                guard let name = params["folderName"] as? String,
                      let type = params["folderType"] as? String
                else {
                    return nil
                }
                
                let tags = params["hashTagList"] as? [String]
                let category = params["categoryIdx"] as? Int
                let detailCategory = params["detailCategoryIdx"] as? Int
                
                // 2000 -> folderName을 입력하세요.
                if name.isEmpty {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2000,
                               "message": "folderName을 입력하세요."
                           }
                           """
                }
                
                // 2001 -> folderName은 30자 이하 문자열입니다.
                if name.count > 30 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2001,
                               "message": "folderName은 30자 이하 문자열입니다."
                           }
                           """
                }
                
                // 2002 -> hashTag는 20자 이하 문자열입니다.
                if let tags = tags,
                   tags.filter({ $0.count > 20 }).count > 0 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2002,
                               "message": "hashTag는 20자 이하 문자열입니다."
                           }
                           """
                }
                
                // 2003 -> folderType을 입력하세요.
                if type.isEmpty {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2003,
                               "message": "folderType을 입력하세요."
                           }
                           """
                }
                
                // 2004 -> folderType은 public 아니면 private입니다.
                if type != "private" && type != "public" {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2004,
                               "message": "folderType은 public 아니면 private입니다."
                           }
                           """
                }
                
                // 2005 -> categoryIdx을 입력하세요.
                if type == "public", category == nil {
                    return """
                           {
                             "isSuccess": false,
                             "code": 2005,
                             "message": "categoryIdx을 입력하세요."
                           }
                           """
                }
                
                // 2006 -> categoryIdx는 1-5 사이의 정수입니다.
                if let category = category,
                   category < 1 || category > 5 {
                    return  """
                            {
                                "isSuccess": false,
                                "code": 2006,
                                "message": "categoryIdx는 1-5 사이의 정수입니다."
                            }
                            """
                }
                
                // 2007 -> detailCategoryIdx를 입력하세요.
                if type == "public", detailCategory == nil {
                    return  """
                            {
                                "isSuccess": false,
                                "code": 2007,
                                "message": "detailCategoryIdx를 입력하세요."
                            }
                            """
                }
                
                // 2008 -> detailCategoryIdx는 1-30 사이의 정수입니다.
                if let detailCategory = detailCategory,
                   detailCategory < 1 || detailCategory > 30 {
                    return  """
                            {
                                "isSuccess": false,
                                "code": 2008,
                                "message": "detailCategoryIdx는 1-30 사이의 정수입니다."
                            }
                            """
                }
                
                // 1000 -> 폴더 수정 성공
                return """
                       {
                           "folderIdx": 21,
                           "isSuccess": true,
                           "code": 1000,
                           "message": "폴더 생성 성공"
                       }
                       """
            }
            return Data((editFolderStub(params: params) ?? "").utf8)
            
        case .deleteFolder(let index):
            // 2000 -> folderIdx에 존재하는 folder가 없습니다.
            if index < 0 {
                return Data(
                        """
                            {
                              "isSuccess": false,
                              "code": 2000,
                              "message": "folderIdx에 존재하는 folder가 없습니다."
                            }
                        """.utf8
                )
            }
            // 1000 -> 폴더 삭제 성공
            return Data(
                    """
                        {
                            "isSuccess": true,
                            "code": 1000,
                            "message": "폴더 삭제 성공"
                        }
                    """.utf8
            )
            
        case .addLink(let index, let params):
            func addLink(index: Int, params: [String: Any]) -> String? {
                guard let name = params["linkName"] as? String,
                      let url = params["linkUrl"] as? String
                else {
                    return nil
                }
                
                let imageURL = params["linkImageUrl"] as? String
                let faviconURL = params["linkFaviconUrl"] as? String
                
                // 2001 -> 링크 이름을 입력해주세요
                if name.isEmpty {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2001,
                               "userIdx": 1,
                               "message": "링크 이름을 입력해주세요"
                           }
                           """
                }
                
                // 2002 -> 링크 이름은 40자 이하로 입력해주세요
                if name.count > 40 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2002,
                               "userIdx": 1,
                               "message": "링크 이름은 40자 이하로 입력해주세요"
                           }
                           """
                }
                
                // 2003 -> 링크가 올바른 링크 형식이 아닙니다
                if url.isValidHttps() == false {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2003,
                               "userIdx": 1,
                               "message": "링크가 올바른 링크 형식이 아닙니다"
                           }
                           """
                }
                
                // 2004 -> 이미지링크가 올바른 링크 형식이 아닙니다
                if let imageURL = imageURL,
                   imageURL.isValidHttps() == false {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2004,
                               "userIdx": 1,
                               "message": "이미지링크가 올바른 링크 형식이 아닙니다"
                           }
                           """
                }
                
                // 2005 -> 파비콘 링크가 올바른 링크 형식이 아닙니다
                if let faviconURL = faviconURL,
                   faviconURL.isValidHttps() == false {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2005,
                               "userIdx": 1,
                               "message": "파비콘 링크가 올바른 링크 형식이 아닙니다"
                           }
                           """
                }
                
                // 2006 -> 잘못된 폴더 번호입니다
                // 2007 -> 선택한 폴더가 존재하지 않습니다
                /// 2007 경우만 test
                if index < 0 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2007,
                               "userIdx": 1,
                               "message": "선택한 폴더가 존재하지 않습니다"
                           }
                           """
                }
                
                // 1000 -> 링크 추가 성공
                return """
                       {
                           "isSuccess": true,
                           "code": 1000,
                           "userIdx": 1,
                           "message": "링크 추가 성공"
                       }
                       """
            }
            return Data((addLink(index: index, params: params) ?? "").utf8)
            
        case .editLink(let index, let params):
            func editLink(index: Int, params: [String: Any]) -> String? {
                guard let name = params["linkName"] as? String,
                      let url = params["linkUrl"] as? String
                else {
                    return nil
                }
                
                let imageURL = params["linkImageUrl"] as? String
                let faviconURL = params["linkFaviconUrl"] as? String
                
                // 2001 -> 링크 이름을 입력해주세요
                if name.isEmpty {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2001,
                               "userIdx": 1,
                               "message": "링크 이름을 입력해주세요"
                           }
                           """
                }
                
                // 2002 -> 링크 이름은 40자 이하로 입력해주세요
                if name.count > 40 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2002,
                               "userIdx": 1,
                               "message": "링크 이름은 40자 이하로 입력해주세요"
                           }
                           """
                }
                
                // 2003 -> 링크가 올바른 링크 형식이 아닙니다
                if url.isValidHttps() == false {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2003,
                               "userIdx": 1,
                               "message": "링크가 올바른 링크 형식이 아닙니다"
                           }
                           """
                }
                
                // 2004 -> 이미지링크가 올바른 링크 형식이 아닙니다
                if let imageURL = imageURL,
                   imageURL.isValidHttps() == false {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2004,
                               "userIdx": 1,
                               "message": "이미지링크가 올바른 링크 형식이 아닙니다"
                           }
                           """
                }
                
                // 2005 -> 파비콘 링크가 올바른 링크 형식이 아닙니다
                if let faviconURL = faviconURL,
                   faviconURL.isValidHttps() == false {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2005,
                               "userIdx": 1,
                               "message": "파비콘 링크가 올바른 링크 형식이 아닙니다"
                           }
                           """
                }
                
                // 2006 -> 잘못된 폴더 번호입니다
                // 2007 -> 선택한 폴더가 존재하지 않습니다
                /// 2007 경우만 test
                if index < 0 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2007,
                               "userIdx": 1,
                               "message": "선택한 폴더가 존재하지 않습니다"
                           }
                           """
                }
                
                // 1000 -> 링크 수정 성공
                return """
                       {
                           "isSuccess": true,
                           "code": 1000,
                           "userIdx": 1,
                           "message": "링크 수정 성공"
                       }
                       """
            }
            return Data((editLink(index: index, params: params) ?? "").utf8)
            
        case .deleteLink(let index):
            if index < 0 { // 2001 -> 잘못된 링크 번호입니다
                return Data(
                    """
                    {
                        "isSuccess": false,
                        "code": 2001,
                        "userIdx": 1,
                        "message": "잘못된 링크 번호입니다"
                    }
                    """.utf8
                )
            } else { // 1000 -> 링크 삭제 성공
                return Data(
                    """
                    {
                        "isSuccess": true,
                        "code": 1000,
                        "userIdx": 1,
                        "message": "링크 삭제 성공"
                    }
                    """.utf8
                )
            }
        
        case .editUserInformation(let params):
            func userInformation(params: [String: Any]) -> String? {
                let name = params["userNickname"] as? String
                let profileURL = params["userProfileImgUrl"] as? String
                let category = params["userCategoryIdx"] as? Int
                let detailCategory = params["userDetailCategoryIdx"] as? Int
                
                // 2003 -> userNickname은 30자 이하로 입력해주세요.
                if let name = name, name.count > 30 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2003,
                               "userIdx": 1,
                               "message": "userNickname은 30자 이하로 입력해주세요."
                           }
                           """
                }
                
                // 2004 -> 프로필 이미지 링크가 올바른 링크 형식이 아닙니다
                if let profileURL = profileURL, profileURL.isValidHttps() == false {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2004,
                               "userIdx": 1,
                               "message": "프로필 이미지 링크가 올바른 링크 형식이 아닙니다"
                           }
                           """
                }
                
                // 2006 -> categoryIdx는 1-5 사이의 정수입니다.
                if let category = category, (category < 1 || category > 5) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2006,
                               "userIdx": 1,
                               "message": " categoryIdx는 1-5 사이의 정수입니다."
                           }
                           """
                }
                
                // 2007 -> categoryIdx가 1일때 detailCategoryIdx는 1~10을 입력하세요.
                if let category = category,
                   let detailCategory = detailCategory,
                   category == 1,
                   (detailCategory < 1 || detailCategory > 10) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2007,
                               "userIdx": 1,
                               "message": "categoryIdx가 1일때 detailCategoryIdx는 1~10을 입력하세요."
                           }
                           """
                }
                
                // 2008 -> categoryIdx가 2일때 detailCategoryIdx는 11~18을 입력하세요.
                if let category = category,
                   let detailCategory = detailCategory,
                   category == 2,
                   (detailCategory < 11 || detailCategory > 18) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2008,
                               "userIdx": 1,
                               "message": "categoryIdx가 2일때 detailCategoryIdx는 11~18을 입력하세요."
                           }
                           """
                }
                
                // 2009 -> categoryIdx가 3일때 detailCategoryIdx는 19~25을 입력하세요.
                if let category = category,
                   let detailCategory = detailCategory,
                   category == 3,
                   (detailCategory < 19 || detailCategory > 25) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2009,
                               "userIdx": 1,
                               "message": "categoryIdx가 3일때 detailCategoryIdx는 19~25을 입력하세요."
                           }
                           """
                }
                
                // 2010 -> categoryIdx가 4일때 detailCategoryIdx는 26~30을 입력하세요.
                if let category = category,
                   let detailCategory = detailCategory,
                   category == 4,
                   (detailCategory < 26 || detailCategory > 30) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2010,
                               "userIdx": 1,
                               "message": "categoryIdx가 4일때 detailCategoryIdx는 26~30을 입력하세요."
                           }
                           """
                }
                
                // 2011 -> categoryIdx가 5일때 detailCategoryIdx를 Body에 담지마세요.
                if let category = category,
                   detailCategory != nil,
                   category == 5 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2011,
                               "userIdx": 1,
                               "message": "categoryIdx가 5일때 detailCategoryIdx를 Body에 담지마세요."
                           }
                           """
                }
                
                // 1000 -> 유저 정보 추가 성공
                return """
                       {
                           "isSuccess": true,
                           "code": 1000,
                           "userIdx": 1,
                           "message": "유저 정보 추가 성공"
                       }
                       """
            }
            return Data((userInformation(params: params) ?? "").utf8)
            
        case .like(let index):
            if index >= 0 {
                // 1000 -> 좋아요 성공
                return Data(
                    """
                    {
                        "isSuccess": true,
                        "code": 1000,
                        "userIdx": 1,
                        "message": "좋아요 성공"
                    }
                    """.utf8
                )
            } else {
                // 2001 -> 잘못된 폴더 번호입니다
                return Data(
                    """
                    {
                        "isSuccess": false,
                        "code": 2001,
                        "userIdx": 1,
                        "message": "잘못된 폴더 번호입니다"
                    }
                    """.utf8
                )
            }
        case .topTenFolder:
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "userIdx": 1,
                  "message": "탑텐 가리비 조회 성공",
                  "result": [
                    {
                      "folderIdx": 3,
                      "userIdx": 2,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "Node",
                      "folderType": "public",
                      "folderLinkCount": 4,
                      "likeFolderCount": 3,
                      "linkImageUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                      "likeStatus": 1
                    },
                    {
                      "folderIdx": 1,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "Web",
                      "folderType": "public",
                      "folderLinkCount": 4,
                      "likeFolderCount": 2,
                      "linkImageUrl": "-1",
                      "likeStatus": 1
                    },
                    {
                      "folderIdx": 4,
                      "userIdx": 2,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "JWT",
                      "folderType": "public",
                      "folderLinkCount": 8,
                      "likeFolderCount": 1,
                      "linkImageUrl": "-1",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 5,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "스택",
                      "folderType": "public",
                      "folderLinkCount": 0,
                      "likeFolderCount": 1,
                      "linkImageUrl": "-1",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 8,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "유니티",
                      "folderType": "public",
                      "folderLinkCount": 0,
                      "likeFolderCount": 1,
                      "linkImageUrl": "-1",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 9,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "딥러닝 이용한 악성코드 탐지",
                      "folderType": "public",
                      "folderLinkCount": 0,
                      "likeFolderCount": 1,
                      "linkImageUrl": "-1",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 10,
                      "userIdx": 2,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "인공지능으로 기후 예측",
                      "folderType": "public",
                      "folderLinkCount": 4,
                      "likeFolderCount": 1,
                      "linkImageUrl": "https://i1.daumcdn.net/svc/image/U03/common_icon/5587C4E4012FCD0001",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 11,
                      "userIdx": 2,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "머신러닝 기초",
                      "folderType": "public",
                      "folderLinkCount": 3,
                      "likeFolderCount": 1,
                      "linkImageUrl": "https://cdn.sstatic.net/Sites/stackoverflow/Img/apple-touch-icon@2.png?v=73d79a89bded",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 2,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 10,
                      "detailCategoryName": "기타",
                      "folderName": "Javascript",
                      "folderType": "public",
                      "folderLinkCount": 2,
                      "likeFolderCount": 0,
                      "linkImageUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                      "likeStatus": 0
                    }
                  ]
                }
                """.utf8
            )
        case .likedFolder:
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "message": "좋아요한 폴더 조회 성공",
                  "resultCount": 6,
                  "result": [
                    {
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 3,
                      "detailCategoryName": "기타",
                      "folderIdx": 63,
                      "folderLinkCount": 0,
                      "folderName": "ios",
                      "folderType": "public",
                      "likeFolderCount": 1,
                      "linkImageUrl": "-1",
                      "likeStatus": 1,
                      "updatedAt": "17시간전"
                    },
                    {
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 1,
                      "detailCategoryName": "기타",
                      "folderIdx": 3,
                      "folderLinkCount": 2,
                      "folderName": "Node",
                      "folderType": "public",
                      "likeFolderCount": 3,
                      "linkImageUrl": "-1",
                      "likeStatus": 1,
                      "updatedAt": "18시간전"
                    },
                    {
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 5,
                      "detailCategoryName": "기타",
                      "folderIdx": 5,
                      "folderLinkCount": 0,
                      "folderName": "스택",
                      "folderType": "public",
                      "likeFolderCount": 2,
                      "linkImageUrl": "-1",
                      "likeStatus": 1,
                      "updatedAt": "19시간전"
                    },
                    {
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "기타",
                      "folderIdx": 53,
                      "folderLinkCount": 1,
                      "folderName": "iOS 개발 기초",
                      "folderType": "public",
                      "likeFolderCount": 1,
                      "linkImageUrl": "https://www.apple.com/ac/structured-data/images/open_graph_logo.png?201809210816",
                      "likeStatus": 1,
                      "updatedAt": "1일전"
                    },
                    {
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 2,
                      "detailCategoryName": "기타",
                      "folderIdx": 1,
                      "folderLinkCount": 8,
                      "folderName": "Web",
                      "folderType": "public",
                      "likeFolderCount": 2,
                      "linkImageUrl": "https://s3-ap-northeast-2.amazonaws.com/opentutorials-user-file/module/2398/4811.png",
                      "likeStatus": 1,
                      "updatedAt": "1일전"
                    },
                    {
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 2,
                      "detailCategoryName": "기타",
                      "folderIdx": 2,
                      "folderLinkCount": 2,
                      "folderName": "Javascript👍",
                      "folderType": "public",
                      "likeFolderCount": 1,
                      "linkImageUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                      "likeStatus": 1,
                      "updatedAt": "2일전"
                    }
                  ]
                }
                """.utf8
            )
        case .usersFolder(_, let params):
            let limit = params["limit"] as? Int
            let page = params["page"] as? Int
            
            // 2008 -> page를 입력하세요.
            if limit == nil {
                return Data(
                    """
                    {
                      "isSuccess": false,
                      "code": 2008,
                      "message": "page를 입력하세요."
                    }
                    """.utf8
                )
            }
            
            // 2009 -> limit를 입력하세요.
            if page == nil {
                return Data(
                    """
                    {
                      "isSuccess": false,
                      "code": 2009,
                      "message": "limit를 입력하세요."
                    }
                    """.utf8
                )
            }
            
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "message": "사용자 링크달조회 성공",
                  "result": [
                    {
                      "folderIdx": 33,
                      "folderName": "추가 테스트",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": -1,
                      "detailCategoryName": "-1",
                      "folderType": "private",
                      "folderLinkCount": 0,
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "updatedAt": "6일전",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 29,
                      "folderName": "유저 2번인데 머지",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": -1,
                      "detailCategoryName": "-1",
                      "folderType": "private",
                      "folderLinkCount": 0,
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "updatedAt": "6일전",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 28,
                      "folderName": "테스트",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": -1,
                      "detailCategoryName": "-1",
                      "folderType": "private",
                      "folderLinkCount": 0,
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "updatedAt": "6일전",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 27,
                      "folderName": "sjjdnd",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": -1,
                      "detailCategoryName": "-1",
                      "folderType": "private",
                      "folderLinkCount": 0,
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "updatedAt": "6일전",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 26,
                      "folderName": "dd",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": -1,
                      "detailCategoryName": "-1",
                      "folderType": "private",
                      "folderLinkCount": 0,
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "updatedAt": "6일전",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 5,
                      "folderName": "스택",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 5,
                      "detailCategoryName": "자료구조/알고리즘",
                      "folderType": "public",
                      "folderLinkCount": 0,
                      "likeFolderCount": 2,
                      "linkImageUrl": "-1",
                      "updatedAt": "6일전",
                      "likeStatus": 1
                    },
                    {
                      "folderIdx": 8,
                      "folderName": "유니티",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 6,
                      "detailCategoryName": "게임",
                      "folderType": "public",
                      "folderLinkCount": 1,
                      "likeFolderCount": 2,
                      "linkImageUrl": "https://velopert.com/wp-content/uploads/2016/12/Untitled-4.png",
                      "updatedAt": "6일전",
                      "likeStatus": 1
                    },
                    {
                      "folderIdx": 9,
                      "folderName": "딥러닝 이용한 악성코드 탐지",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 7,
                      "detailCategoryName": "빅데이터",
                      "folderType": "public",
                      "folderLinkCount": 0,
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "updatedAt": "6일전",
                      "likeStatus": 0
                    },
                    {
                      "folderIdx": 1,
                      "folderName": "Web",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 2,
                      "detailCategoryName": "웹",
                      "folderType": "public",
                      "folderLinkCount": 8,
                      "likeFolderCount": 2,
                      "linkImageUrl": "https://s3-ap-northeast-2.amazonaws.com/opentutorials-user-file/module/2398/4811.png",
                      "updatedAt": "1주전",
                      "likeStatus": 1
                    },
                    {
                      "folderIdx": 2,
                      "folderName": "Javascript",
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 2,
                      "detailCategoryName": "웹",
                      "folderType": "public",
                      "folderLinkCount": 2,
                      "likeFolderCount": 1,
                      "linkImageUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                      "updatedAt": "1주전",
                      "likeStatus": 0
                    }
                  ]
                }
                """.utf8
            )
        case .categoryDetail(let mainIndex, let subIndex, let params):
            func categoryDetail(
                category: Int,
                detailCategory: Int,
                params: [String: Any]
            ) -> String? {
                let limit = params["limit"] as? Int
                let lastFolderIdx = params["lastFolderIdx"] as? Int
                
                // 2002 -> categoryIdx는 1-5 사이의 정수입니다.
                if (category < 1 || category > 5) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2002,
                               "message": " categoryIdx는 1-5 사이의 정수입니다."
                           }
                           """
                }
                
                // 2004 -> categoryIdx가 1일때 detailCategoryIdx는 1~10을 입력하세요.
                if category == 1,
                   (detailCategory < 1 || detailCategory > 10) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2004,
                               "message": "categoryIdx가 1일때 detailCategoryIdx는 1~10을 입력하세요."
                           }
                           """
                }
                
                // 2005 -> categoryIdx가 2일때 detailCategoryIdx는 11~18을 입력하세요.
                if category == 2,
                   (detailCategory < 11 || detailCategory > 18) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2005,
                               "message": "categoryIdx가 2일때 detailCategoryIdx는 11~18을 입력하세요."
                           }
                           """
                }
                
                // 2006 -> categoryIdx가 3일때 detailCategoryIdx는 19~25을 입력하세요.
                if category == 3,
                   (detailCategory < 19 || detailCategory > 25) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2006,
                               "message": "categoryIdx가 3일때 detailCategoryIdx는 19~25을 입력하세요."
                           }
                           """
                }
                
                // 2007 -> categoryIdx가 4일때 detailCategoryIdx는 26~30을 입력하세요.
                if category == 4,
                   (detailCategory < 26 || detailCategory > 30) {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2007,
                               "userIdx": 1,
                               "message": "categoryIdx가 4일때 detailCategoryIdx는 26~30을 입력하세요."
                           }
                           """
                }
                
                // 2008 -> categoryIdx가 5일때 detailCategoryIdx는 0을 입력하세요.
                if category == 5, detailCategory != 0 {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2008,
                               "message": "categoryIdx가 5일때 detailCategoryIdx는 0을 입력하세요."
                           }
                           """
                }
                
                // 2012 -> limit를 입력하세요.
                if limit == nil {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2012,
                               "message": "limit를 입력하세요."
                           }
                           """
                }
                
                // 2013 -> lastFolderIdx를 입력하세요.
                if lastFolderIdx == nil {
                    return """
                           {
                               "isSuccess": false,
                               "code": 2013,
                               "message": "lastFolderIdx를 입력하세요."
                           }
                           """
                }
                
                // 1000 -> 카테고리별 링크달 조회 성공
                return """
                       {
                         "isSuccess": true,
                         "code": 1000,
                         "message": "카테고리별 링크달 조회 성공",
                         "result": {
                           "folderCount": 1,
                           "folderList": [
                             {
                               "folderIdx": 3,
                               "folderName": "Node",
                               "folderType": "public",
                               "detailCategoryIdx": 1,
                               "detailCategoryName": "서버",
                               "folderLinkCount": 2,
                               "likeFolderCount": 3,
                               "linkImageUrl": "http://asq.kr/IzK7AyGzMFQADk",
                               "updatedAt": "1일전",
                               "likeStatus": 1
                             }
                           ]
                         }
                       }
                       """
            }
            
            let stub = categoryDetail(category: mainIndex, detailCategory: subIndex, params: params)
            return Data((stub ?? "").utf8)
        
        case .searchFolder(let params):
            let isMyFolders = params["isMyFolders"] as? Int
            let limit = params["limit"] as? Int
            let page = params["page"] as? Int
            
            // 2003 -> 잘못된 기준 번호입니다
            if isMyFolders == nil {
                return Data(
                        """
                           {
                               "isSuccess": false,
                               "code": 2003,
                               "userIdx": 1,
                               "message": "잘못된 기준 번호입니다",
                               "resultCount": 0,

                           }
                        """.utf8
                )
            }
             
            if let isMyFolders = isMyFolders,
               (isMyFolders < 0) || (isMyFolders > 1) {
                return Data(
                        """
                           {
                               "isSuccess": false,
                               "code": 2003,
                               "userIdx": 1,
                               "message": "잘못된 기준 번호입니다",
                               "resultCount": 0,

                           }
                        """.utf8
                )
            }
            
            // 4000 -> userCheck DB error
            if limit == nil || page == nil {
                return Data(
                        """
                           {
                               "isSuccess": false,
                               "code": 4000,
                               "userIdx": 1,
                               "message": "serCheck DB error",
                               "resultCount": 0,

                           }
                        """.utf8
                )
            }
            
            // 1000 -> (내)폴더 검색 성공
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "userIdx": 1,
                  "message": "폴더 검색 성공",
                  "resultCount": 60,
                  "result": [
                    {
                      "folderIdx": 72,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드1",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 73,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드2",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 112,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드41",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 128,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드57",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 104,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드33",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 88,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드17",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 131,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드60",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 96,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드25",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 80,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드9",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    },
                    {
                      "folderIdx": 81,
                      "folderLinkCount": 0,
                      "userIdx": 1,
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryIdx": 4,
                      "detailCategoryName": "안드로이드",
                      "folderName": "안드로이드10",
                      "folderType": "public",
                      "likeFolderCount": 0,
                      "linkImageUrl": "-1",
                      "likeStatus": 0,
                      "folderUpdatedAt": "1시간전"
                    }
                  ]
                }
                """.utf8
            )
        
        case .searchLink(let params):
            let page = params["page"] as? Int
            let limit = params["limit"] as? Int
            let isMyFolders = params["isMyFolders"] as? Int
            
            // 2011 -> page를 입력하세요
            if limit == nil {
                return Data(
                    """
                    {
                      "isSuccess": false,
                      "code": 2011,
                      "userIdx": 1,
                      "message": "page를 입력하세요",
                      "resultCount": 0,
                      "result": []
                    }
                    """.utf8
                )
            }
            
            // 2012 -> limit를 입력하세요
            if page == nil {
                return Data(
                    """
                    {
                      "isSuccess": false,
                      "code": 2012,
                      "userIdx": 1,
                      "message": "limit를 입력하세요",
                      "resultCount": 0,
                      "result": []
                    }
                    """.utf8
                )
            }
            
            // 2003 -> 잘못된 기준 번호입니다
            if isMyFolders == nil {
                return Data(
                    """
                    {
                      "isSuccess": false,
                      "code": 1000,
                      "userIdx": 1,
                      "message": "링크 검색 성공",
                      "resultCount": 0,
                      "result": []
                    }
                    """.utf8
                )
            }
            
            if let isMyFolders = isMyFolders,
               (isMyFolders < 0) || (isMyFolders > 1) {
                return Data(
                    """
                    {
                      "isSuccess": false,
                      "code": 1000,
                      "userIdx": 1,
                      "message": "링크 검색 성공",
                      "resultCount": 0,
                      "result": []
                    }
                    """.utf8
                )
            }
            
            // 1000 -> (내)링크 검색 성공
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "userIdx": 1,
                  "message": "링크 검색 성공",
                  "resultCount": 4,
                  "result": [
                    {
                      "linkIdx": 1,
                      "folderIdx": 8,
                      "userIdx": 1,
                      "linkName": "editTestLInk",
                      "linkUrl": "https://velopert.com/2389",
                      "linkImageUrl": "https://velopert.com/wp-content/uploads/2016/12/Untitled-4.png",
                      "linkFaviconUrl": "-1",
                      "folderUpdatedAt": "1주전"
                    },
                    {
                      "linkIdx": 5,
                      "folderIdx": 3,
                      "userIdx": 1,
                      "linkName": "[Node.js 강좌] Node.js 란 개념과 소개",
                      "linkUrl": "http://sblog.netraweb.com/node-js-%EA%B0%95%EC%A2%8C-node-js-%EB%9E%80-%EA%B0%9C%EB%85%90%EA%B3%BC-%EC%86%8C%EA%B0%9C/",
                      "linkImageUrl": "http://sblog.netraweb.com/wp-content/uploads/2017/12/node-js-01.png",
                      "linkFaviconUrl": "-1",
                      "folderUpdatedAt": "2주전"
                    },
                    {
                      "linkIdx": 6,
                      "folderIdx": 3,
                      "userIdx": 1,
                      "linkName": "Node.js 서버 개발",
                      "linkUrl": "https://edu.goorm.io/lecture/3534/node-js-%EC%84%9C%EB%B2%84-%EA%B0%9C%EB%B0%9C",
                      "linkImageUrl": "http://asq.kr/IzK7AyGzMFQADk",
                      "linkFaviconUrl": "-1",
                      "folderUpdatedAt": "2주전"
                    },
                    {
                      "linkIdx": 21,
                      "folderIdx": 1,
                      "userIdx": 1,
                      "linkName": "test",
                      "linkUrl": "https://www.naver.com",
                      "linkImageUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                      "linkFaviconUrl": "-1",
                      "folderUpdatedAt": "1주전"
                    }
                  ]
                }
                """.utf8
            )
        
        case .report(let params):
            let index = params["folderIdx"]
            
            /// 2000 -> folderIdx를 입력하세요.
            if index == nil {
                return Data(
                    """
                    {
                        "isSuccess": false,
                        "code": 1000,
                        "message": "신고하기 성공"
                    }
                    """.utf8
                )
            }
            
            ///  2001 -> folderIdx는 정수입니다.
            if index as? Int == nil {
                return Data(
                    """
                    {
                        "isSuccess": false,
                        "code": 2001,
                        "message": "folderIdx는 정수입니다."
                    }
                    """.utf8
                )
            }

            /// 1000 -> 신고하기 성공
            return Data(
                """
                {
                    "reportIdx": 4,
                    "isSuccess": true,
                    "code": 1000,
                    "message": "신고하기 성공"
                }
                """.utf8
            )
        
        case .categories:
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "message": "카테고리 조회 성공",
                  "result": [
                    {
                      "categoryIdx": 1,
                      "categoryName": "개발",
                      "detailCategoryList": [
                        {
                          "detailCategoryIdx": 1,
                          "detailCategoryName": "서버"
                        },
                        {
                          "detailCategoryIdx": 2,
                          "detailCategoryName": "웹"
                        },
                        {
                          "detailCategoryIdx": 3,
                          "detailCategoryName": "iOS"
                        },
                        {
                          "detailCategoryIdx": 4,
                          "detailCategoryName": "안드로이드"
                        },
                        {
                          "detailCategoryIdx": 5,
                          "detailCategoryName": "자료구조/알고리즘"
                        },
                        {
                          "detailCategoryIdx": 6,
                          "detailCategoryName": "게임"
                        },
                        {
                          "detailCategoryIdx": 7,
                          "detailCategoryName": "빅데이터"
                        },
                        {
                          "detailCategoryIdx": 8,
                          "detailCategoryName": "AI"
                        },
                        {
                          "detailCategoryIdx": 9,
                          "detailCategoryName": "머신러닝"
                        },
                        {
                          "detailCategoryIdx": 10,
                          "detailCategoryName": "기타"
                        }
                      ]
                    },
                    {
                      "categoryIdx": 2,
                      "categoryName": "디자인",
                      "detailCategoryList": [
                        {
                          "detailCategoryIdx": 11,
                          "detailCategoryName": "UI/UX"
                        },
                        {
                          "detailCategoryIdx": 12,
                          "detailCategoryName": "웹"
                        },
                        {
                          "detailCategoryIdx": 13,
                          "detailCategoryName": "그래픽"
                        },
                        {
                          "detailCategoryIdx": 14,
                          "detailCategoryName": "모바일"
                        },
                        {
                          "detailCategoryIdx": 15,
                          "detailCategoryName": "광고"
                        },
                        {
                          "detailCategoryIdx": 16,
                          "detailCategoryName": "BI/BX"
                        },
                        {
                          "detailCategoryIdx": 17,
                          "detailCategoryName": "디자인리소스"
                        },
                        {
                          "detailCategoryIdx": 18,
                          "detailCategoryName": "기타"
                        }
                      ]
                    },
                    {
                      "categoryIdx": 3,
                      "categoryName": "마케팅/광고",
                      "detailCategoryList": [
                        {
                          "detailCategoryIdx": 19,
                          "detailCategoryName": "디지털마케팅"
                        },
                        {
                          "detailCategoryIdx": 20,
                          "detailCategoryName": "콘텐츠마케팅"
                        },
                        {
                          "detailCategoryIdx": 21,
                          "detailCategoryName": "소셜마케팅"
                        },
                        {
                          "detailCategoryIdx": 22,
                          "detailCategoryName": "브랜드마케팅"
                        },
                        {
                          "detailCategoryIdx": 23,
                          "detailCategoryName": "제휴마케팅"
                        },
                        {
                          "detailCategoryIdx": 24,
                          "detailCategoryName": "키워드광고"
                        },
                        {
                          "detailCategoryIdx": 25,
                          "detailCategoryName": "기타"
                        }
                      ]
                    },
                    {
                      "categoryIdx": 4,
                      "categoryName": "기획",
                      "detailCategoryList": [
                        {
                          "detailCategoryIdx": 26,
                          "detailCategoryName": "일반"
                        },
                        {
                          "detailCategoryIdx": 27,
                          "detailCategoryName": "서비스"
                        },
                        {
                          "detailCategoryIdx": 28,
                          "detailCategoryName": "전략"
                        },
                        {
                          "detailCategoryIdx": 29,
                          "detailCategoryName": "프로젝트"
                        },
                        {
                          "detailCategoryIdx": 30,
                          "detailCategoryName": "기타"
                        }
                      ]
                    },
                    {
                      "categoryIdx": 5,
                      "categoryName": "기타",
                      "detailCategoryList": []
                    }
                  ]
                }
                """.utf8
            )
        
        case .userInformation:
            /// 1000 -> 사용자 정보 조회 성공
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "message": "사용자 정보 조회 성공",
                  "result": [
                    {
                      "userIdx": 1,
                      "userStrategy": 2,
                      "userNickname": "Casey",
                      "userEmail": "khykhy1006@gmail.com",
                      "userProfileImgUrl": "https://s.pstatic.net/static/www/mobile/edit/2016/0705/mobile_212852414260.png",
                      "userCategoryIdx": 1
                    }
                  ]
                }
                """.utf8
            )
        case .deleteAccount:
            /// 1000 -> 회원탈퇴 성공
            return Data(
                """
                {
                    "isSuccess": true,
                    "code": 1000,
                    "message": "회원탈퇴 성공"
                }
                """.utf8
            )
            
        case .todayFolder:
            /// 1000 -> 회원탈퇴 성공
            return Data(
                """
                {
                  "isSuccess": true,
                  "code": 1000,
                  "userIdx": 1,
                  "message": "오늘의 추천 링크달 조회 성공",
                  "result": [
                    {
                      "folderIdx": 64,
                      "userIdx": 2,
                      "categoryIdx": 2,
                      "categoryName": "디자인",
                      "detailCategoryIdx": 17,
                      "detailCategoryName": "디자인리소스",
                      "folderName": "디자인 다른거",
                      "folderType": "public",
                      "folderLinkCount": 0,
                      "likeFolderCount": 1,
                      "linkImageUrl": "-1",
                      "likeStatus": 0
                    }
                  ]
                }
                """.utf8
            )
            
        default:
            return Data()
        }
    }
}
