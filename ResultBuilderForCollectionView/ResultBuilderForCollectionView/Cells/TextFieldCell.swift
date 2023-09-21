//
//  TextFieldCell.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct TextFieldItem: Item {
    var id: String    
    var title: String?
    var placeHolder: String?
    var textDidChange: ((String?) -> Void)?
}

final class TextFieldCell: UICollectionViewCell {

    var title: String? { didSet { setNeedsUpdateConfiguration() } }
    var placeHolder: String? { didSet { setNeedsUpdateConfiguration() } }
    var textDidChange: ((String?) -> Void)? { didSet { setNeedsUpdateConfiguration() } }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        var config = TextFieldCellConfiguration().updated(for: state)
                
        config.title = title
        config.placeHolder = placeHolder
        config.textDidChange = { [weak self] text in
            self?.title = text
            self?.textDidChange?(text)
        }
        
        contentConfiguration = config
        backgroundConfiguration = CellBackgroundConfiguration.configuration(for: state)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 45)
    }
}
