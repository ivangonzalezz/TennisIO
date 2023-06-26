//
//  ContentView.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 27/4/23.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext)
    var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)])
    var items : FetchedResults<TennisDataEntity>
    
    var body: some View {
        VStack {
            NavigationStack {
                NavigationLink {
                    SelectMovementTypeView()
                } label: {
                    Text("Start movements")
                }
                
                NavigationLink {
                    ListSavedMovementsView()
                } label: {
                    Text("Show saved movements")
                }
            }
            .navigationTitle("Title")
        }
    }
}
