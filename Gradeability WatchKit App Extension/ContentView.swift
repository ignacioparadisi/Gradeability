//
//  ContentView.swift
//  Gradeability WatchKit App Extension
//
//  Created by Ignacio Paradisi on 7/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private let context = CoreDataManagerFactory.createManager.context
    var body: some View {
        List {
            NavigationLink(destination: SubjectsView().environment(\.managedObjectContext, context)) {
                Text("Subjects")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
