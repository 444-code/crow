//
//  ContentView.swift
//  crow
//
//  Created by Константин Девяткин on 18.11.2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    init(){
        self.size = UIScreen.main.bounds.size
        self.gameScene = GameScene()
        self.gameScene.size = size
    }
    var gameScene: GameScene
    let size: CGSize
    
    var body: some View {
        SpriteView(scene: gameScene)
            .ignoresSafeArea()
            .frame(width: size.width, height: size.height)
        
            .statusBarHidden(true)
        
        
        
        
    }
}

#Preview {
    ContentView()
}
