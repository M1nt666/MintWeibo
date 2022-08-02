//
//  ContentView.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
            .environmentObject(UserData())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

