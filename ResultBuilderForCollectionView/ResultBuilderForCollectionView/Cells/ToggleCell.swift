//
//  ToggleCell.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct ToggleItem: Item {
    var id: String    
    var title: String?
    var isOn: Bool = false
    var switchDidToggle: ((Bool) -> Void)?
}

final class ToggleCell: UICollectionViewCell {

    var title: String = "" { didSet { setNeedsUpdateConfiguration() } }
    var isOn: Bool = false { didSet { setNeedsUpdateConfiguration() } }
    
    var switchDidToggle: ((Bool) -> Void)? { didSet { setNeedsUpdateConfiguration() } }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        var config = ToggleCellConfiguration().updated(for: state)
        
        config.title = title
        config.isOn = isOn
        config.switchDidToggle = { [weak self] isOn in
            self?.isOn = isOn
            self?.switchDidToggle?(isOn)
        }
        
        contentConfiguration = config
        backgroundConfiguration = CellBackgroundConfiguration.configuration(for: state)
    }
}
