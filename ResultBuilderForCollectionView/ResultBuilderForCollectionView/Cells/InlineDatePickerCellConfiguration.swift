//
//  InlineDatePickerCellConfiguration.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct InlineDatePickerCellConfiguration: UIContentConfiguration, Hashable {
    
    var date: Date = Date()
    
    var dateDidSelect: ((Date) -> Void)?
    
    func makeContentView() -> UIView & UIContentView {
        return InlineDatePickerCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> InlineDatePickerCellConfiguration {
        guard let _ = state as? UICellConfigurationState else { return self }
        
        let updatedConfig = self
        
        return updatedConfig
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
    
    static func == (lhs: InlineDatePickerCellConfiguration, rhs: InlineDatePickerCellConfiguration) -> Bool {
        return lhs.date == rhs.date
    }
}

final class InlineDatePickerCellContentView: UIView, UIContentView {
    
    init(configuration: InlineDatePickerCellConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
        
        layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? InlineDatePickerCellConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        return picker
    }()
    
    private var dateDidSelect: ((Date) -> Void)?
    
    @objc
    private func dateSelectAction(_ datePicker: UIDatePicker) {
        dateDidSelect?(datePicker.date)
    }

    private func setupInternalViews() {
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.rightAnchor.constraint(equalTo: rightAnchor),
            datePicker.leftAnchor.constraint(equalTo: leftAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private var appliedConfiguration: InlineDatePickerCellConfiguration!
    
    private func apply(configuration: InlineDatePickerCellConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration

        dateDidSelect = { [weak self] date in
            self?.appliedConfiguration.date = date
            configuration.dateDidSelect?(date)
        }
        datePicker.addTarget(self, action: #selector(dateSelectAction(_:)), for: .valueChanged)
        
        datePicker.setDate(configuration.date, animated: false)
    }
}
