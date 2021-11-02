//
//  widgetBoxView.swift
//  LinkMoaWidgetExtension
//
//  Created by Beomcheol Kwon on 2021/03/24.
//

import SwiftUI
import LinkMoaCore
import LinkMoaKit
import Kingfisher

struct WidgetBoxView: View {
    var todayFolder: [TodayFolder.Result] = []
    var name: String {
        if todayFolder.count > 0 {
            return todayFolder[0].name
        } else {
            return "준비되지 않음"
        }
    }
    
    var linkCount: Int {
        if todayFolder.count > 0 {
            return todayFolder[0].linkCount
        } else {
            return 0
        }
    }
    
    var linkImageURL: String {
        if todayFolder.count > 0, todayFolder[0].linkImageURL != "-1" {
            return todayFolder[0].linkImageURL
        } else {
            return Constant.defaultImageURL
        }
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .overlay(KFImage(URL(string: linkImageURL))
                            .resizable()
                            .scaledToFill())
            
            Rectangle()
                .foregroundColor(Color.black.opacity(0.2))
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(name)
                    .font(.custom("NotoSansKR-Bold", fixedSize: 15))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                HStack {
                    Image("whiteSeashell")
                        .frame(width: 14, height: 12.45, alignment: .center)
                        .padding(3)
                    
                    Text(linkCount.toAbbreviationString)
                        .font(.custom("NotoSansKR-Bold", fixedSize: 15))
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                }
            }
            .padding(.init(16))
        }
        .background(Color.gray)
    }
}

struct WidgetBoxView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetBoxView()
    }
}
