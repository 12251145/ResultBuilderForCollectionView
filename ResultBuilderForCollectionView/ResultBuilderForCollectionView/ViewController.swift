//
//  ViewController.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

struct StateModel {
    var title: String?
    var showForm: Bool
    let navigateItems: [String] = ["메뉴 1", "메뉴 2", "메뉴 3"]
    var showDatePicker: Bool
    var date: Date
}

class ViewController: UICollectionViewController {
    
    var stateModel = StateModel(showForm: false, showDatePicker: false, date: Date()) {
        didSet {
            let newForm = form(from: stateModel)
            setForm(newForm)
        }
    }
    var dataSource: UICollectionViewDiffableDataSource<Int, String>?
    var data: [String: Item] = [:]
    
    init() {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var configiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)

            configiguration.backgroundColor = .clear            

            let section = NSCollectionLayoutSection.list(using: configiguration, layoutEnvironment: layoutEnvironment)
                        
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)

            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        
        layout.configuration = config
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.delaysContentTouches = false
        
        title = "CollectionView"
        
        configureDataSource()
        setForm(form(from: stateModel))
    }
    
    func configureDataSource() {
        let textFieldCellRegistration = UICollectionView.CellRegistration<TextFieldCell, TextFieldItem> { cell, indexPath, item in
            
            cell.title = item.title
            cell.placeHolder = item.placeHolder
            cell.textDidChange = item.textDidChange
        }
        let toggleCellRegistration = UICollectionView.CellRegistration<ToggleCell, ToggleItem> { cell, indexPath, item in
            
            cell.title = item.title ?? ""
            cell.isOn = item.isOn
            cell.switchDidToggle = item.switchDidToggle
        }
        let navigateCellRegistration = UICollectionView.CellRegistration<NavigateCell, NavigateItem> { cell, indexPath, item in
            
            cell.title = item.title
        }
        let inlineDatePickerCellRegistration = UICollectionView.CellRegistration<InlineDatePickerCell, InlineDatePickerItem> { cell, indexPath, item in
            
            cell.date = item.date
            cell.dateDidSelect = item.dateDidSelect
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, String>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                guard let item = self?.data[itemIdentifier] else { fatalError() }
                
                switch item {
                case let textFieldItem as TextFieldItem:
                    return collectionView.dequeueConfiguredReusableCell(using: textFieldCellRegistration, for: indexPath, item: textFieldItem)
                case let toggleItem as ToggleItem:
                    return collectionView.dequeueConfiguredReusableCell(using: toggleCellRegistration, for: indexPath, item: toggleItem)
                case let navigateItem as NavigateItem:
                    return collectionView.dequeueConfiguredReusableCell(using: navigateCellRegistration, for: indexPath, item: navigateItem)
                case let inlineDatePickerItem as InlineDatePickerItem:
                    return collectionView.dequeueConfiguredReusableCell(using: inlineDatePickerCellRegistration, for: indexPath, item: inlineDatePickerItem)
                default: fatalError()
                }
            }
        )
    }
    
    func setForm(_ form: [Section]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        
        for (i, section) in form.enumerated() {
            
            for item in section.items {
                data[item.id] = item
            }
            
            snapshot.appendSections([i])
            
            snapshot.appendItems(
                section.items.map { $0.id },
                toSection: i
            )
        }
        
        dataSource?.apply(snapshot)
    }

    @SectionArrayBuilder
    func form(from model: StateModel) -> [Section] {
        Section {
            ToggleItem(id: "1", title: "형식 보기", isOn: model.showForm) { [weak self] isOn in
                self?.stateModel.showForm = isOn
            }
        }
        
        if model.showForm {
            Section {
                TextFieldItem(id: "2", title: model.title, placeHolder: "제목") { [weak self] text in
                    self?.stateModel.title = text
                }
            }
            
            Section {
                for (i, title) in model.navigateItems.enumerated() {
                    NavigateItem(id: "\(i + 3)", title: title)
                }
            }
            
            Section {
                ToggleItem(id: "6", title: "날짜 선택", isOn: model.showDatePicker) { [weak self] isOn in
                    self?.stateModel.showDatePicker = isOn
                }
                
                if model.showDatePicker {
                    InlineDatePickerItem(id: "7", date: model.date)
                }
            }
        }
    }
}
