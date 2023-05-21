//
//  SelectMovementTypeView.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 30/4/23.
//

import SwiftUI

struct SelectMovementTypeView: View {
    @State private var selectedMovementKind = "Drive"
    let movementKinds = ["Drive", "Backhand"]
    
    @State var timeNow = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Movement Kind", selection: $selectedMovementKind) {
                    ForEach(movementKinds, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.inline)
            }
        }
        NavigationLink {
            GatherDataView(movementKind: selectedMovementKind)
        } label: {
            Text("Start!")
        }
    }
}
/*
struct SelectMovementTypeView_Previews: PreviewProvider {
    static var previews: some View {
        //SelectMovementTypeView()
    }
}
*/
