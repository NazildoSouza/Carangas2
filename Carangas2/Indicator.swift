//
//  Indicator.swift
//  Carangas2
//
//  Created by Nazildo Souza on 27/04/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        ZStack {
            Blur(style: .systemUltraThinMaterial)
            
            VStack {
                Indicator()
                Text("Aguarde")
                    .foregroundColor(.primary)
                    .padding(.top, 8)
            }
        }
        .frame(width: 110, height: 110)
        .cornerRadius(15)
    }
}

struct Indicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
