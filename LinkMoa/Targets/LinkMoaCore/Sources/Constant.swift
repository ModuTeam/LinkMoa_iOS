//
//  Constant.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/17.
//

import UIKit

public struct Constant {
    public struct FAQ {
        public let question: String
        public let answer: String
    }

    public static let pageLimit: Int = 20
    
    public static let faqData = Constant.faqQuestions.map {
        FAQ(question: $0.question, answer: $0.answer)
    }
    
    public static let faqQuestions: [(question: String, answer: String)] = [
        ("링크달과 가리비가 뭔가요?", "가리비는 인터넷 링크이며, 링크달은 링크를 저장하는 폴더입니다."),
        ("링크달을 비공개로 해놓으면 다른 사람들은 볼 수 없나요?",  "비공개인 링크달은 다른 유저에게 보이지 않습니다."),
        ("링크달 추가는 어떻게 하나요?", "메인화면 우측 하단의 '+' 버튼을 눌러 링크달을 추가할 수 있습니다."),
        ("가리비 추가는 어떻게 하나요?", "메인화면 우측 하단의 '+' 버튼을 눌러 가리비를 추가할 수 있습니다. 또한, 사파리에서 공유 버튼을 눌러서 추가할 수도 있습니다."),
        ("링크달 공유는 어떻게 하나요?", "공유할 링크달에 들어간 후 오른쪽 상단에 있는 메뉴 버튼을 눌러서 공유할 수 있습니다."),
        ("링크달 신고는 어떻게 하나요?", "신고할 링크달에 들어간 후 오른쪽 상단에 있는 메뉴 버튼을 눌러서 신고할 수 있습니다. 신고된 링크달은 관리자의 판단에 하에 경고 없이 삭제될 수 있습니다."),
        ("검색은 어떻게 하나요?", "나의 링크달에서는 내가 만든 링크달만 검색할 수 있습니다. 서핑하기에서는 모든 사용자가 공개한 링크달을 검색할 수 있습니다."),
        ("실수로 링크달을 삭제했습니다. 데이터를 복원할 수 있나요?", "한 번 삭제한 링크달과 가리비는 복구할 수 없습니다."),
        ("회원탈퇴를 하면 데이터는 어떻게 되나요?", "회원 탈퇴 직전의 모든 데이터는 서버에 저장되며, 탈퇴 후에는 수정하거나 삭제가 불가능합니다. 재가입 후에도 기존 데이터를 수정하실 수 없으니 탈퇴 전 데이터 정리를 꼭 하시길 바랍니다.")
    ]
    
    public static var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        return version
    }
    
    public static var iOSVersion: String? {
        let os = ProcessInfo().operatingSystemVersion
        let iOSVersion = String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
        return iOSVersion
    }

    public static let devTestToken: String = "    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo0MSwiaWF0IjoxNjE2NDY2NDY1LCJleHAiOjE2NDgwMDI0NjUsInN1YiI6InVzZXJJbmZvIn0.1-CZ0p7iNvClZImkNaFRrkvBtHEcqL-68rBTk8YDgxw"
    
    public static let defaultImageURL: String = "https://i.imgur.com/NnjvaEe.png"
    
    public static let categoryData: [Int: String] = [
        1: "개발",
        2: "디자인",
        3: "마케팅/광고",
        4: "기획",
        5: "기타"
    ]
    
    public static let detailCategoryData: [Int: [Int: String]] = [
        1: [
            1: "서버",
            2: "웹",
            3: "iOS",
            4: "안드로이드",
            5: "자료구조/알고리즘",
//            6: "게임", // 서버 에러로 인한 임시 삭제 - 8월 1일
//            7: "빅데이터", // 해당 값으로 추가시 서버 다운 됨
//            8: "AI",
//            9: "머신러닝",
            10: "기타"
        ],
        2: [
            11: "UI/UX",
            12: "웹",
            13: "그래픽",
            14: "모바일",
            15: "광고",
            16: "BI/BX",
            17: "디자인리소스",
            18: "기타"
        ],
        3: [
            19: "디지털마케팅",
            20: "콘텐츠마케팅",
            21: "소셜마케팅",
            22: "브랜드마케팅",
            23: "제휴마케팅",
            24: "키워드광고",
            25: "기타"
        ],
        4: [
            26: "일반",
            27: "서비스",
            28: "전략",
            29: "프로젝트",
            30: "기타"
        ]
    ]
}
