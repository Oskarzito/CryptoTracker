//
//  CryptoApp.swift
//  Crypto
//
//  Created by Oskar Emilsson on 2025-02-03.
//

import SwiftUI
import Lottie

@main
struct CryptoApp: App {
    
    @StateObject var mainViewModel = MainViewModel()
    @State var isLoading: Bool = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().backgroundColor = .white.withAlphaComponent(0.15)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                
                if mainViewModel.isLoading {
                    cryptoLoader
                        .frame(width: 200, height: 200)
                        
                } else {
                    ContentView()
                        .environmentObject(mainViewModel)
                }
            }
            .onAppear {
                mainViewModel.fetchOverviewData()
            }
        }
    }
    
    private var cryptoLoader: some View {
        LottieView(animation: .named("crypto-loader"))
            .looping()
    }
}
