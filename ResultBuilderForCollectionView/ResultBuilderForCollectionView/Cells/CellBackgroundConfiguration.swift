//
//  CellBackgroundConfiguration.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/22.
//

import UIKit

struct CellBackgroundConfiguration {
    static func configuration(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        
        background.backgroundColor = .secondarySystemBackground
        
        return background
    }
}
