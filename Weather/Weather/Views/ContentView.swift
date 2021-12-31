//
//  ContentView.swift
//  Weather
//
//  Created by Mohammed Aleem on 25/12/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @StateObject var locationManager = LocationManager()
    @State var isWeatherFetchInprogress = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    if let name = item.name {
                        HStack {
                            Text(name)
                            Spacer()
                            Text(item.minTemperature.formatted)
                            Text(item.maxTemperature.formatted).foregroundColor(.gray)
                            
                            if let icon = item.icon {
                                ImageView(withURL: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle(Text("Weather"))
        .onAppear {
           print("onAppear")
        }
        .onReceive(self.locationManager.didUpdateLocation, perform: { location in
            print("didUpdateLocation: \(location.coordinate.latitude) \(location.coordinate.longitude)")
            guard let latitude = locationManager.lastLocation?.coordinate.latitude, let longitude = locationManager.lastLocation?.coordinate.longitude else {
                return
            }
            
            if (self.items.isEmpty && !self.isWeatherFetchInprogress) || latitude.dt(value: location.coordinate.latitude) > 0.01 || longitude.dt(value: location.coordinate.longitude) > 0.01 {
                self.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
            print("willEnterForeground")
            guard let latitude = locationManager.lastLocation?.coordinate.latitude, let longitude = locationManager.lastLocation?.coordinate.longitude else {
                return
            }
            self.fetchWeather(latitude: latitude, longitude: longitude)
        })
    }
    
    private func updateItems(weatherResponse: WeatherResponse) {
        guard let weatherList = weatherResponse.list else { return }
        for weatherObject in weatherList {
            if let name = weatherObject.name, let minTemp = weatherObject.main?.tempMin, let maxTemp = weatherObject.main?.tempMax, let description = weatherObject.weather?.first?.description, let icon = weatherObject.weather?.first?.icon {
                self.addItem(name: name, min: minTemp, max: maxTemp, description: description, icon: icon)
            }
        }
    }
    
    private func fetchWeather(latitude: Double, longitude: Double) {
        guard Reachability.isConnectedToNetwork() else { return }
        self.isWeatherFetchInprogress = true
        self.deleteAll()
        print("fetchWeather: Started")
        WeatherService.shared.fetchWeather(latitue: latitude, longitude: longitude) { result in
            switch result {
            case .success(let weatherResponse):
                self.updateItems(weatherResponse: weatherResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
            print("fetchWeather: Finished")
            self.isWeatherFetchInprogress = false
        }
    }

    private func addItem(name: String?, min: Double, max: Double, description: String?, icon: String?) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = name
            newItem.minTemperature = min
            newItem.maxTemperature = max
            newItem.weatherDescription = description
            newItem.icon = icon

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteAll() {
        
        for item in self.items {
            viewContext.delete(item)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
