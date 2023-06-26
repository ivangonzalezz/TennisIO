//
//  ListSavedMovementsView.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 11/5/23.
//

import SwiftUI
import CoreData
import WatchConnectivity
import Foundation

struct ListSavedMovementsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "identifier", ascending: false),
        NSSortDescriptor(key: "timestamp", ascending: true)
    ])
    var items : FetchedResults<TennisDataEntity>
    
    var body: some View {
        let groupedTrainments = Dictionary(grouping: items, by: {$0.identifier})
        Button("Remove all") {
            let fetch : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TennisDataEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                print(groupedTrainments.keys)
                try managedObjectContext.execute(deleteRequest)
            } catch {
                
            }
        }
        let keysArray = Array(groupedTrainments.keys).sorted(by: {
                    if let date1 = $0, let date2 = $1 {
                        return date1 > date2
                    } else if $0 == nil && $1 != nil {
                        return false
                    } else {
                        return true
                    }
                })
        
        List(keysArray, id: \.self) { trainment in
            Button("\(formatDate(date: trainment ?? Date(), format: "dd-MM-yyyy hh:mm:ss")) - \((groupedTrainments[trainment] ?? [])[0].kind ?? "")") {
                do {
                    var jsonArray = [[String: Any]]()
                    var identifier = ""
                    
                    
                    for item in groupedTrainments[trainment] ?? [] {
                        var jsonObject = [String: Any]()
                        identifier = formatDate(date: item.identifier ?? Date(), format: "dd-MM-yyyy hh:mm:ss")
                        jsonObject["identifier"] = identifier
                        jsonObject["xRotation"] = item.xRotation
                        jsonObject["yRotation"] = item.yRotation
                        jsonObject["zRotation"] = item.zRotation
                        jsonObject["pitch"] = item.pitch
                        jsonObject["yaw"] = item.yaw
                        jsonObject["roll"] = item.roll
                        jsonObject["xAcceleration"] = item.xAcceleration
                        jsonObject["yAcceleration"] = item.yAcceleration
                        jsonObject["zAcceleration"] = item.yAcceleration
                        jsonObject["kind"] = item.kind ?? ""
                        jsonObject["timestamp"] = formatDate(date: item.timestamp ?? Date(), format: "dd-MM-yyyy hh:mm:ss")
                        
                        jsonArray.append(jsonObject)
                    }
                    let jsonData = try! JSONSerialization.data(withJSONObject: jsonArray)
                    var apiURL = URL(string: Bundle.main.infoDictionary?["API_URL"] as! String)
                    
                    var request = URLRequest(url: apiURL!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    request.httpMethod = "POST"
                    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonArray)
                    
                    let task = URLSession.shared.dataTask(with: request)
                    task.resume() 
                } catch {
                    
                }
            }
        }
        
    }
}

struct ListSavedMovementsView_Previews: PreviewProvider {
    static var previews: some View {
        ListSavedMovementsView()
    }
}
