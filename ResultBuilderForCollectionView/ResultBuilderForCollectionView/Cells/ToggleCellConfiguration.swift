//
//  ToggleCellConfiguration.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct ToggleCellConfiguration: UIContentConfiguration, Hashable {
    
    var title: String = ""
    var isOn: Bool = false
    
    var switchDidToggle: ((Bool) -> Void)?
    
    func makeContentView() -> UIView & UIContentView {
        return ToggleCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ToggleCellConfiguration {
        guard let _ = state as? UICellConfigurationState else { return self }
        
        let updatedConfig = self
        
        return updatedConfig
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(isOn)
    }
    
    static func == (lhs: ToggleCellConfiguration, rhs: ToggleCellConfiguration) -> Bool {
        return lhs.title == rhs.title &&
            lhs.isOn == rhs.isOn
    }
}

final class ToggleCellContentView: UIView, UIContentView {
    
    init(configuration: ToggleCellConfiguration) {
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
            guard let newConfig = newValue as? ToggleCellConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private var switchDidToggle: ((Bool) -> Void)?
    
    @objc
    private func switchToggleAction(_ toggle: UISwitch) {

        switchDidToggle?(toggle.isOn)
    }

    private func setupInternalViews() {
        addSubview(titleLabel)
        addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            toggleSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            toggleSwitch.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor)
        ])
    }
    
    private var appliedConfiguration: ToggleCellConfiguration!
    
    private func apply(configuration: ToggleCellConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration

        switchDidToggle = { [weak self] isOn in
            self?.appliedConfiguration.isOn = isOn
            configuration.switchDidToggle?(isOn)
        }
        
        toggleSwitch.addTarget(self, action: #selector(switchToggleAction(_:)), for: .valueChanged)
        toggleSwitch.setOn(configuration.isOn, animated: false)
        
        titleLabel.text = configuration.title            
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 45)
    }
}
