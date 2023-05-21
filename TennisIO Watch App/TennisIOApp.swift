//
//  TennisIOApp.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 27/4/23.
//

import SwiftUI
import CoreData


@main
struct TennisIO_Watch_AppApp: App {
    //let tennisData : TennisData = TennisData()
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
