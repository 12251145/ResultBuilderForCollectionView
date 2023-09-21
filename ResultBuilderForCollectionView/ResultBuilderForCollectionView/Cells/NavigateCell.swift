//
//  NavigateCell.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct NavigateItem: Item {
    var id: String
    var title: String
}

final class NavigateCell: UICollectionViewCell {

    var title: String = "" { didSet { setNeedsUpdateConfiguration() } }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        var config = NavigateCellConfiguration().updated(for: state)
        
        config.title = title
        
        contentConfiguration = config
        backgroundConfiguration = HighlightableCellBackgroundConfiguration.configuration(for: state)
    }
}
