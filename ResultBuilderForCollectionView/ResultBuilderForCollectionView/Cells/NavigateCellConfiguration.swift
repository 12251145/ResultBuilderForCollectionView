//
//  NavigateCellConfiguration.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct NavigateCellConfiguration: UIContentConfiguration, Hashable {
    
    var title: String = ""
    
    func makeContentView() -> UIView & UIContentView {
        return NavigateCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> NavigateCellConfiguration {
        guard let _ = state as? UICellConfigurationState else { return self }
        
        let updatedConfig = self
        
        return updatedConfig
    }
}

final class NavigateCellContentView: UIView, UIContentView {
    
    init(configuration: NavigateCellConfiguration) {
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
            guard let newConfig = newValue as? NavigateCellConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var chevronImage: UIImageView = {
        let image = UIImage(systemName: "chevron.right")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .bold, scale: .large))
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        return imageView
    }()

    private func setupInternalViews() {
        addSubview(titleLabel)
        addSubview(chevronImage)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            chevronImage.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            chevronImage.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
        ])
    }
    
    private var appliedConfiguration: NavigateCellConfiguration!
    
    private func apply(configuration: NavigateCellConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        titleLabel.text = configuration.title
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 45)
    }
}
