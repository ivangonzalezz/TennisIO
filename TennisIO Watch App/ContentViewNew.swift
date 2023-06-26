//
//  ContentViewNew.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 28/4/23.
//
/*
import SwiftUI
import CoreMotion
import CoreData



struct ContentViewNew: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SensorData.timestamp, ascending: true)],
        animation: .default)
    private var motionData: FetchedResults<SensorData>
    
    let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Motion Data:")
                .font(.headline)
            List(motionData) { data in
                SensorDataView(data: data)
            }
        }
        .onAppear(perform: startMotionDataCollection)
        .onDisappear(perform: stopMotionDataCollection)
    }
    
    func startMotionDataCollection() {
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotionData, error) in
            guard let data = deviceMotionData else { return }
            
            let motion = SensorData(context: viewContext)
            //let rotationRateData = try? NSKeyedArchiver.archivedData(withRootObject: data.rotationRate, requiringSecureCoding: false)
            //let attitudeData = try? NSKeyedArchiver.archivedData(withRootObject: data.attitude, requiringSecureCoding: false)
            //let userAccelerationData = try? NSKeyedArchiver.archivedData(withRootObject: data.userAcceleration, requiringSecureCoding: false)
            
            motion.attitude = data.attitude
            motion.rotationRate = data.rotationRate
            motion.userAcceleration = data.userAcceleration
            motion.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func stopMotionDataCollection() {
        motionManager.stopDeviceMotionUpdates()
    }
    
}

struct SensorDataView: View {
    @State var data: SensorData
    @FetchRequest(entity: SensorData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SensorData.timestamp, ascending: false)])
    var sensorDataList: FetchedResults<SensorData>

    var body: some View {
        VStack {
            if let lastData = sensorDataList.first {
                Text("Attitude: \(lastData.attitude.pitch ?? 0), \(lastData.attitude.roll ?? 0), \(lastData.attitude.yaw ?? 0)")
                Text("Rotation Rate: \(lastData.rotationRate.x ?? 0), \(lastData.rotationRate.y ?? 0), \(lastData.rotationRate.z ?? 0)")
                Text("User Acceleration: \(lastData.userAcceleration.x ?? 0), \(lastData.userAcceleration.y ?? 0), \(lastData.userAcceleration.z ?? 0)")
            } else {
                Text("No data available")
            }
        }
    }
    
}
*/
