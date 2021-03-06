//
//  Cards.swift
//  FamCards
//
//  Created by Garima Bothra on 26/06/21.
//

import SwiftUI

//MARK: Main View - Card Groups View

struct CardGroupsView: View {
    @ObservedObject var viewModel: GroupsViewModel
    
    init(viewModel: GroupsViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader() { geometry in
            NavigationView {
                    switch (viewModel.state) {
                    case .loading:
                        ProgressView().onAppear(perform: viewModel.refresh)
                    case .failed:
                        VStack {
                        Image("errorImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            Button("Try again", action: {viewModel.refresh()})
                        }
                    case .loaded:
                        ScrollView() {
                    VStack(spacing: 10) {
                        Spacer()
                        if let cardViewModels = viewModel.dataSource?.cardGroups {
                            ForEach((0..<cardViewModels.count), id: \.self){
                                let design = cardViewModels[$0].designType
                                CardRow(viewModel: cardViewModels[$0])
                                    .frame(height: geometry.size.height * CGFloat(getHeight(designType: design)))
                            }
                        }
                        Spacer()
                            .frame(minHeight: 20)
                    }
                    }
                        .padding()
                        .background(Color(hexCode: "#F2F3F3"))
                        .frame(width: geometry.size.width,height: geometry.size.height)
                        .onAppear(perform: viewModel.refresh)
                }
            }
        }
    }
}
