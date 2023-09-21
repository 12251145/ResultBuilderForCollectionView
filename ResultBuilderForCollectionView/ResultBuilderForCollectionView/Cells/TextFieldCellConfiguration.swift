//
//  TextFieldCellConfiguration.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct TextFieldCellConfiguration: UIContentConfiguration, Hashable {
    
    var title: String?
    var placeHolder: String?
    var textDidChange: ((String?) -> Void)?
    
    func makeContentView() -> UIView & UIContentView {
        return TextFieldCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> TextFieldCellConfiguration {
        guard let _ = state as? UICellConfigurationState else { return self }
        
        let updatedConfig = self
        
        return updatedConfig
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(placeHolder)
    }
    
    static func == (lhs: TextFieldCellConfiguration, rhs: TextFieldCellConfiguration) -> Bool {
        return lhs.title == rhs.title &&
        lhs.placeHolder == rhs.placeHolder
    }
}

final class TextFieldCellContentView: UIView, UIContentView {
    
    init(configuration: TextFieldCellConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
        
        layoutMargins = .init(top: 5, left: 16, bottom: 5, right: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? TextFieldCellConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.font = .systemFont(ofSize: 16)
        return textField
    }()
    
    private var textDidChange: ((String?) -> Void)?
    
    @objc
    private func textDidChangeAction(_ textField: UITextField) {
        textDidChange?(textField.text)
    }

    private func setupInternalViews() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textField.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            textField.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private var appliedConfiguration: TextFieldCellConfiguration!
    
    private func apply(configuration: TextFieldCellConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration

        textDidChange = { [weak self] text in
            self?.appliedConfiguration.title = text
            configuration.textDidChange?(text)
        }
        textField.addTarget(self, action: #selector(textDidChangeAction(_:)), for: .editingChanged)
        
        textField.text = configuration.title
        textField.placeholder = configuration.placeHolder
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 45)
    }
}
