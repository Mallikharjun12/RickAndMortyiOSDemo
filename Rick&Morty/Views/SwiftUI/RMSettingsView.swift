//
//  RMSettingsView.swift
//  Rick&Morty
//
//  Created by Mallikharjun kakarla on 29/04/23.
//

import SwiftUI

struct RMSettingsView: View {
    
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
        
    }
    
    var body: some View {
        
            List(viewModel.cellViewModels) { viewModel in
                HStack {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.red)
                            .background(Color(viewModel.iconContainerColor))
                            .padding(8)
                            .cornerRadius(6)
                            
                    }
                    Text(viewModel.title)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.bottom, 3)
                .onTapGesture {
                    viewModel.onTapHandler(viewModel.type)
                }
            }
      }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in
                
            }
        })))
    }
}
