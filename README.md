# ResultBuilderForCollectionView

```swift
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
```

### From

```swift
var items: [[any Item]] = []

items.append([
    ToggleItem(id: "1", title: "형식 보기", isOn: model.showForm) { [weak self] isOn in
        self?.stateModel.showForm = isOn
    }
])

if model.showForm {
    items.append([
        TextFieldItem(id: "2", title: model.title, placeHolder: "제목") { [weak self] text in
            self?.stateModel.title = text
        }
    ])
    
    let navigateItems = model.navigateItems.enumerated().map { (i, title) in
        NavigateItem(id: "\(i + 3)", title: title)
    }
    
    items.append(navigateItems)
    
    var datePickerItems: [any Item] = [
        ToggleItem(id: "6", title: "날짜 선택", isOn: model.showDatePicker) { [weak self] isOn in
            self?.stateModel.showDatePicker = isOn
        }
    ]
    
    if model.showDatePicker {
        datePickerItems.append(InlineDatePickerItem(id: "7", date: model.date))
    }
    
    items.append(datePickerItems)
}

return items
```
