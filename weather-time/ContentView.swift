//
//  ContentView.swift
//  weather-time
//
//  Created by Batista Tone on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNight = false
    @State private var selectedDay: String = ""
    
    @ObservedObject var weatherData = WeatherData()
    
    var body: some View {
        ZStack {
            BackgroundColorView(isNight: $isNight)
            VStack (spacing: 8) {
                CityName(name:" \(weatherData.forecastInfo.weekDay) at \(weatherData.forecastInfo.address) ")
                   
               
                TemperatureStatusIcon(imageName: weatherData.icons[weatherData.forecastInfo.actualDay.icon] ?? weatherData.forecastInfo.actualDay.icon, temperature: weatherData.forecastInfo.actualDay.temp, description: weatherData.forecastInfo.actualDay.description)
                
                
                    ScrollView(.horizontal){
                        HStack (spacing: 20) {
                            
                        ForEach(weatherData.weatherDays, id: \.day) { item in
            
                            Button {
                                self.weatherData.forecastInfo = ForeCastInfo(
                                    address: self.weatherData.forecastInfo.address, actualDay: Day(description: item.description, datetime: item.datetime, temp: item.temperature, icon: item.imageName), weekDay: self.weatherData.getWeekDayByString(date: item.datetime)
                                )
                                self.selectedDay = item.datetime
                            }label: {
                                VStack {
                                    WeatherDayView(day: item.day, imageName: item.imageName, temperature: item.temperature,dateTime: item.datetime,  selectedWeekDay: $selectedDay)
                                        
                                }
                              
                            }
                            
                           
                        }
                        .padding(.bottom, 15)
                        .padding(.horizontal, 10)
                        
                    }
                   
              } .onAppear {
                  self.weatherData.fetchWeather()
              }
                
                Spacer()
                
                Button{
                    isNight.toggle()
                }label: {
                    WeatherButton(title: "Change day Time", textColor: .blue, bgColor: .white)
                }
                
                
                Spacer()
                
                    
            }
        }
       
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherDayView: View {
    
    var day:String
    var imageName: String
    var temperature: Double
    var dateTime: String
    @Binding var selectedWeekDay: String
    
    
    var body: some View {
        
        if(selectedWeekDay == dateTime){
            VStack {
                Text(day)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                Image(systemName: imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(3)
                    
                Text("\(String(format: "%.1f", temperature))º")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                    .padding(.horizontal, 10)
                
                
            }
            .background(Color.teal)
            .cornerRadius(5)
        }else{
            VStack {
                Text(day)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                Image(systemName: imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(3)
                    
                Text("\(String(format: "%.1f", temperature))º")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                    .padding(.horizontal, 10)
                
                
            }
            
            .cornerRadius(5)
        }
        
       
       
        
    }
}

struct BackgroundColorView: View {
    
   @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(
            colors:[isNight ? .black :.blue , isNight ? .gray : Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomLeading)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityName: View {
    var name: String
    var body: some View {
        Text(name)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}


struct TemperatureStatusIcon: View {
    
    var imageName:String
    var temperature: Double
    var description: String
    
    var body: some View {
        VStack {
            Image(systemName:imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(String(format: "%.1f", temperature))º C")
            .font(.system(size: 70, weight: .medium))
            .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding(.top, 1)
        }
        .padding(.bottom, 40)
    }
}


