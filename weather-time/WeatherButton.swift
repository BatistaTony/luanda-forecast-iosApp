//
//  WeatherButton.swift
//  weather-time
//
//  Created by Batista Tone on 06/05/23.
//

import SwiftUI


struct WeatherButton: View {
    var title: String
    var textColor: Color
    var bgColor: Color
    
    var body: some View {
        Text(title)
            .foregroundColor(textColor)
            .frame(width: 280, height: 50)
            .background(bgColor)
            .font(.system(size:20, weight: .bold, design: .default))
            .cornerRadius(10)
    }
}

