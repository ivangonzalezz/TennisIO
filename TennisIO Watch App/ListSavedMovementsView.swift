//
//  ListSavedMovementsView.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 11/5/23.
//

import SwiftUI
import CoreData
import WatchConnectivity

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
                    
                    
                    
                    for item in groupedTrainments[trainment] ?? [] {
                        var jsonObject = [String: Any]()
                        jsonObject["identifier"] = formatDate(date: item.identifier ?? Date(), format: "dd-MM-yyyy hh:mm:ss")
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
                        /*
                        print(jsonObject)
                        var request = URLRequest(url: URL(string: "http://localhost:8000/uploadMovements/")!)
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        request.httpMethod = "POST"
                        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
                        print(request.httpBody)
                        let task = URLSession.shared.dataTask(with: request)
                        task.resume()
                         */
                    }
                    let jsonData = try! JSONSerialization.data(withJSONObject: jsonArray)
                    
                    var request = URLRequest(url: URL(string: "http://192.168.1.225:8000/uploadMovements/")!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    request.httpMethod = "POST"
                    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonArray)
                    
                    let task = URLSession.shared.dataTask(with: request)
                    task.resume()
                    
                    //print(try! JSONSerialization.jsonObject(with: jsonData))
                    //let fileManager = FileManager.default
                    //let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    //let fileURL = documentsDirectory.appendingPathComponent("\(formatDate(date: trainment ?? Date(), format: "dd-MM-yyyy_hh.mm.ss")).json")

                    //try jsonData.write(to: fileURL)
                    //print(fileURL)
                    
                    
                    /*
                    let session = WCSession.default
                    session?.delegate = self
                    session.activate()
                    print("Activated")
                    if session.isReachable {
                        print("Is reachable")
                        session.transferFile(fileURL, metadata: nil)
                    }
                     */
                } catch {
                    
                }
            }
        }
        //let keys : [Date?] = (groupedTrainments.keys)
        
    }
}

struct ListSavedMovementsView_Previews: PreviewProvider {
    static var previews: some View {
        ListSavedMovementsView()
    }
}
