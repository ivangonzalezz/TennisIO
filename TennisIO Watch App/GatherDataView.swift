//
//  GatherDataView.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 30/4/23.
//

import SwiftUI
import CoreMotion
import CoreData
import UIKit
import WatchKit

struct GatherDataView: View {
    let movementKind : String
    let motionManager = CMMotionManager()
    @State var update = false
    @State var rotationRate : CMRotationRate!
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext    
    
    
    func startMotionDataCollection() {
        WKExtension.shared().isAutorotating = true
        update = true
        let startingDate = Date()
        var i : Int = 0
        motionManager.deviceMotionUpdateInterval = 0.02
        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotionData, error) in
            guard let data = deviceMotionData else {return}
            if !update {
                return
            }
            let movement = TennisDataEntity(context: managedObjectContext)
            rotationRate = data.rotationRate
            
            movement.xRotation = data.rotationRate.x
            movement.yRotation = data.rotationRate.y
            movement.zRotation = data.rotationRate.z
            movement.pitch = data.attitude.pitch
            movement.roll = data.attitude.roll
            movement.yaw = data.attitude.yaw
            movement.xAcceleration = data.userAcceleration.x
            movement.yAcceleration = data.userAcceleration.y
            movement.zAcceleration = data.userAcceleration.z
            movement.timestamp = Date(timeIntervalSinceNow: data.timestamp - ProcessInfo.processInfo.systemUptime)
            movement.identifier = startingDate
            movement.kind = movementKind
            i += 1
            print("Movement \(i) generated - ID \(movement.objectID)")
        }
    }
    
    func stopMotionDataCollection() {
        motionManager.stopDeviceMotionUpdates()
        update = false
        WKExtension.shared().isAutorotating = false
        
    }
    
    var body: some View {
        Text("Registering \(movementKind) data")
        if let data = rotationRate {
            Text("Rotation data: X - \(rotationRate.x), Y - \(rotationRate.y), Z - \(rotationRate.z)")
        }
        
        Button("Stop movement") {
            motionManager.stopDeviceMotionUpdates()
            PersistenceController.shared.save()
            dismiss()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: startMotionDataCollection)
        .onDisappear(perform: stopMotionDataCollection)
    }
}
