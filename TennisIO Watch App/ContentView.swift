//
//  ContentView.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 27/4/23.
//

import SwiftUI
import CoreData

//var tennisData : TennisData = TennisData()
//var t : TennisDataEntity = TennisDataEntity(entity: tennisData.getEntity(), insertInto: tennisData.getContext())

struct ContentView: View {
    //@State var fetch = tennisData.fetchRequest()
    //@State var count = tennisData.count(fetch)
    //@ObservedObject var tennisData : TennisDataEntity
    //@State var tennisData : TennisData
    @Environment(\.managedObjectContext)
    var managedObjectContext
    //@Environment(\.managedObjectContext)
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)])
    var items : FetchedResults<TennisDataEntity>
    //@FetchRequest(entity: TennisDataEntity.entity(), sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: true)])
    //var items: FetchedResults<TennisDataEntity>
    
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
                
                Button("Add element") {
                    let movement = TennisDataEntity(context: managedObjectContext)
                    let random = [
                        [Date(timeIntervalSince1970: 100000), "Drive"],
                        [Date(timeIntervalSince1970: 5000000), "Backhand"],
                        [Date(timeIntervalSince1970: 400000), "Drive"]
                    ]
                    let r = Int.random(in: 0..<3)
                    func randomNumber() -> Double {
                        return Double.random(in: -1.001...1.001)
                    }
                    movement.xRotation = randomNumber()
                    movement.yRotation = randomNumber()
                    movement.zRotation = randomNumber()
                    movement.pitch = randomNumber()
                    movement.roll = randomNumber()
                    movement.yaw = randomNumber()
                    movement.xAcceleration = randomNumber()
                    movement.yAcceleration = randomNumber()
                    movement.zAcceleration = randomNumber()
                    movement.identifier = random[r][0] as! Date
                    movement.kind = random[r][1] as! String
                    movement.timestamp = Date()
                    PersistenceController.shared.save()
                    
                }
                
                /*
                ForEach(tennisData.getElements(fetchRequest: fetch), id: \.self) { element in
                    NavigationLink(destination: Text("View")) {
                        let dateFormatter : DateFormatter = {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm:ss"
                            return dateFormatter
                        }()
                        Text("\(dateFormatter.string(from: element.timestamp ?? Date()))")
                    }
                }
                 */
                Text("\(String(items.count))")
                /*
                Button(action: tennisData.addElement) {
                    Text("Add element")
                }
                Text("\(tennisData.entity)")
                //Text(() {return "hello"})
                let text : String = {
                    return String(tennisData.count(fetchRequest: fetch))
                }()
                Text(text)
                //Text("\(tennisData.deleteAll() ? "True" : "False")")
                 */
            }
            .navigationTitle("Title")
        }
    }
}
/*
struct ContentView_Previews: PreviewProvider {
    var tennis : TennisData = TennisData()
    static var previews: some View {
        ContentView(tennisData: tennis)
    }
}
*/

