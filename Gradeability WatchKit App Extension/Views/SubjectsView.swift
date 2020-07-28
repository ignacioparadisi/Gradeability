//
//  SubjectsView.swift
//  Gradeability WatchKit App Extension
//
//  Created by Ignacio Paradisi on 7/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import SwiftUI//3752692

struct SubjectsView: View {
    let viewModel = SubjectsViewModel()
    var body: some View {
        if viewModel.subjects.isEmpty {
            return AnyView(Text("You have no Subjects created."))
        } else {
            return AnyView(List(viewModel.subjects, id: \.id) { subject in
                Text(subject.name ?? "")
            })
        }
    }
}

struct SubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsView()
    }
}
