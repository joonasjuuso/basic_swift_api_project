//
//  ContentView.swift
//  project
//
//  Created by Joonas Juuso on 6.9.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var GoToNavigation = false
    var body: some View {
        ZStack
              {
                 Color( red: 245/255, green: 245/255, blue: 250/255 ).edgesIgnoringSafeArea( .all )  // Background
             VStack( spacing: 64 )
             {
                Text("Tervetuloa sovellukseen").font(Font.largeTitle)
                
                Button( action:
                            {
                                self.GoToNavigation = true
                            })
                {
                    Text("Jatka")
                }
                .padding( 32 )
                .background( Color.pink )
                .foregroundColor( Color.white )
                .font( .title )
                .cornerRadius( 20 ) // rounded corners for the button
                .sheet(isPresented: $GoToNavigation)
                {
                    WeatherRow( GoToGame: self.$GoToNavigation, temp: String(0.0))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


