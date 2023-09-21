//
//  InlineDatePickerCell.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct InlineDatePickerItem: Item {
    var id: String
    var date: Date
    var dateDidSelect: ((Date) -> Void)?
}

final class InlineDatePickerCell: UICollectionViewCell {
    
    var date: Date = Date() { didSet { setNeedsUpdateConfiguration() } }
    var dateDidSelect: ((Date) -> Void)? { didSet { setNeedsUpdateConfiguration() } }

    override func updateConfiguration(using state: UICellConfigurationState) {
        
        var config = InlineDatePickerCellConfiguration().updated(for: state)
        
        config.date = date
        config.dateDidSelect = { [weak self] date in
            self?.date = date
            self?.dateDidSelect?(date)
        }
        
        contentConfiguration = config
        backgroundConfiguration = CellBackgroundConfiguration.configuration(for: state)
    }
}
