//
//  ContentView.swift
//  傳統字形󠄁
//
//  Created by Tian on 2023-06-17.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var convertedText = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("傳統字形󠄁轉換器󠄁")
                .font(Font.custom("Hiragino Mincho ProN W6", size: 30))
            
            TextEditor(text: $inputText)
                .frame(height: 190)
                .frame(width:  370)
                .font(Font.custom("Hiragino Mincho ProN", size: 15))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(1)
            
            Button("轉換", action: {
                convertText()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Retreat the keyboard
            })
                .font(Font.custom("Hiragino Mincho ProN W6", size: 20))
                .padding()
            
            TextEditor(text: $convertedText)
                .frame(height: 190)
                .frame(width:  370)
                .font(Font.custom("Hiragino Mincho ProN", size: 15))
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(1)
            
            Button("複製文󠄁本", action: copyToClipboard)
                .font(Font.custom("Hiragino Mincho ProN W6", size: 20))
                .padding()
        }
        .preferredColorScheme(.dark)
    }
    
    private func convertText() {
        guard let jsonURL = URL(string: "https://raw.githubusercontent.com/LijiangnanTian/Traditional-Glyph-Forms/main/%E8%88%8A%E5%AD%97%E5%BD%A2.json") else {
            print("Invalid JSON URL.")
            return
        }
        
        CharacterConverter.loadJSON(from: jsonURL) { mappings in
            if let mappings = mappings {
                DispatchQueue.main.async {
                    convertedText = CharacterConverter.convertToKyujitai(input: inputText, mappings: mappings)
                }
            } else {
                print("Failed to load JSON.")
            }
        }
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = convertedText
    }
}
