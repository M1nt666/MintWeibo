//
//  HomeView.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/21.
//

import SwiftUI

struct HomeView: View {
    @State var leftPercent: CGFloat = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                HScrollViewController(pageWidth: geometry.size.width,
                                      contentSize: CGSize(width: geometry.size.width * 2, height: geometry.size.height), content: {
                    HStack{
                        PostListView(category: .recommend)
                            .frame(width: UIScreen.main.bounds.width)
                        PostListView(category: .hot)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }, leftPercent: self.$leftPercent)
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarItems(leading: HomeNavigationBar(leftPercent: $leftPercent))
                .navigationBarTitle("首页", displayMode: .inline)
            }
        }
        //适配iPad样式与iPhone一致
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserData())
    }
}
