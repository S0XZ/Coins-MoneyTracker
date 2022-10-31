//
//  PageView.swift
//  Coins
//
//  Created by 老人 on 17/09/2022.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        VStack (){
            PageViewController(pages: pages, currentPage: $currentPage)
            
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.horizontal)
                .background(.thinMaterial)
                .cornerRadius(15)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: [
            Text("2"),
            Text("3")
        ])
            .aspectRatio(3 / 2, contentMode: .fit)
    }
}
