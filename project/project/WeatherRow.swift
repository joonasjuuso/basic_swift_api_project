//
//  WeatherRow.swift
//  project
//
//  Created by Joonas Juuso on 13.9.2021.
//

import SwiftUI

struct CurrentLocalWeather: Decodable {
    let base: String
    let clouds: Clouds
    let cod: Int
    let coord: Coord
    let dt: Int
    let id: Int
    let main: Main
    let name: String
    let sys: Sys
    let visibility: Int
    let weather: [WeatherFrom]
    let wind: Wind
}
struct Clouds: Decodable {
    let all: Int
}
struct Coord: Decodable {
    let lat: Double
    let lon: Double
}
struct Main: Decodable {
    let humidity: Int
    let pressure: Int
    let temp: Double
    let tempMax: Double
    let tempMin: Double
    private enum CodingKeys: String, CodingKey {
        case humidity, pressure, temp, tempMax = "temp_max", tempMin = "temp_min"
    }
}
struct Sys: Decodable {
    let country: String
    let id: Int
    let sunrise: UInt64
    let sunset: UInt64
    let type: Int
}
struct WeatherFrom: Decodable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}
struct Wind: Decodable {
    let deg: Int
    let speed: Double
}

struct Kaupunki: Hashable, Identifiable {
    let name: String
    let id = UUID()
    var lampotila: String
    
    init(_ given_name: String) {
        name = given_name
        lampotila = SetTemp(given_name)
    }
}

func SetTemp( _ given_name : String) -> String
{
    var temps: String = "0"
    let url = "https://api.openweathermap.org/data/2.5/weather?q="+given_name+"&appid=xxxxxxxxxxxx"
    let objurl = URL(string: url)
    let semaphore = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: objurl!) {(data, response, error) in

        do {
            let forecast = try JSONDecoder().decode(CurrentLocalWeather.self, from: data!)
            temps = String(format: "%.1f", forecast.main.temp - 272.15)
            print(String(forecast.main.temp))
            semaphore.signal()
        } catch {
            print(error)
            return
        }

    }.resume()
    
    semaphore.wait()
    
    return temps
}

struct Weather: Identifiable {
    var id = UUID()
    var name: [Kaupunki]
    var maakunta: String
}

struct WeatherRow: View {
    
    @State private var singleSelection : UUID?
    @Binding var GoToGame: Bool
    var temp: String
    
    
    private let weather_list: [Weather] = [
        Weather(name: [Kaupunki("Oulu")], maakunta: "Pohjois-pohjanmaa"),
        Weather(name: [Kaupunki("Helsinki")], maakunta: "Länsi-uusimaa")]
    
    
    var body: some View {
        NavigationView {
            List(selection: $singleSelection) {
                ForEach(weather_list) { region in
                    Section(header: Text(region.maakunta)) {
                        ForEach(region.name) { name in
                            NavigationLink(destination: Text(name.name).font(.largeTitle)) {
                            HStack {
                                Text(name.lampotila)
                                    .frame(width: 100, height: 10, alignment: .leading)
                                VStack {
                                    Text(name.name)
                                }
                            }.font(.title)
                }
            }
            }
        }
    }
            .navigationTitle("Kaupungit")
            .toolbar { EditButton() }
        }
        ZStack {
            Button( action:
                        {
                            self.GoToGame = false
                        })
            {
                Text("Return").font(Font.largeTitle)
            }
    }
}
}
