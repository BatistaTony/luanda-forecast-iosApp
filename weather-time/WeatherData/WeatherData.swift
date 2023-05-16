//
//  WeatherData.swift
//  weather-time
//
//  Created by Batista Tone on 06/05/23.
//

import Foundation


var API_KEY = "8M4UGVL5Q5HFX2ZMFBEM5A4RY"
var API_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/luanda?unitGroup=metric&key=8M4UGVL5Q5HFX2ZMFBEM5A4RY&contentType=json"

struct WeatherDataModel {
    var day:String
    var imageName: String
    var temperature: Double
    var datetime: String
    var description: String
}



class WeatherData: ObservableObject {
    
    var icons = [
        "cloudly": "cloud.fill",
        "partly-cloudy-day": "cloud.fill",
        "clear-night":"cloud.moon.fill",
        "clear-day":"cloud.sun",
        "partly-cloudy-night": "cloud.moon.fill",
        "rain":"cloud.rain.fill"
    ]

    
     
    @Published var forecastInfo: ForeCastInfo = ForeCastInfo(address: "", actualDay: Day(description: "", datetime: "", temp: 0.0, icon: ""), weekDay: "");
    @Published var weatherDays: [WeatherDataModel] = []
    
    
    func getWeekDayByString(date: String)-> String{
        let date = MyDate.parse(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"
        let weekDay: String = dateFormatter.string(from: date)
        
        return weekDay
    }
    
    func fetchWeather(){
        
        let url = URL(string: API_URL)
        let session  = URLSession(configuration: .default)
        
        if let url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let error {
                    print("Error tryng to fetch the data", error)
                }else {
                    if let data  {
                        let decoder = JSONDecoder()
                        do {
                            let results = try decoder.decode(ForeCast.self, from: data)
                           
                            DispatchQueue.main.async {
                                
                                for day in results.days{
                                   
                                    self.weatherDays.append(
                                        WeatherDataModel(day: String(self.getWeekDayByString(date:day.datetime).prefix(3)), imageName: self.icons[day.icon] ?? "cloud.fill", temperature: day.temp, datetime: day.datetime, description: day.description)
                                    )
                                }
                                
                                let firstElement = results.days[results.days.count-1]
                                self.forecastInfo.address = results.address
                                self.forecastInfo.actualDay = firstElement
                                self.forecastInfo.weekDay = self.getWeekDayByString(date: firstElement.datetime)
                                
                                
                            }
                            
                            print(MyDate.parse(results.days[0].datetime))
                            
                        }catch {
                            print("Error trying decoder the data", error)
                        }
                        
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
}

struct ForeCastInfo {
    var address: String
    var actualDay: Day
    var weekDay: String
}


struct ForeCast: Decodable {
    let address: String
    let days: [Day]
}

struct Day: Decodable {
    let description: String
    let datetime: String
    let temp: Double
    let icon: String
    
}


class MyDate {

    class func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
}
