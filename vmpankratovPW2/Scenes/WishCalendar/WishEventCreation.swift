//
//  WishEventCreation.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 03.12.2024.
//

import UIKit

final class WishEventCreationView: UIViewController {
    enum Constants {
        static let titlePlaceHolder: String = "Name of wish"
        static let descriptionPlaceHolder: String = "Description of wish"
        static let saveTitle: String = "Save"
        static let stackSpacing: CGFloat = 15
        static let stackPadding: CGFloat = 20
        static let updateTitle: String = "Renewed desire"
        static let errorTitle: String = "Error"
        static let fillMessage: String = "Please fill in all fields"
        static let okTitle: String = "OK"
        static let dateErrorMessage: String = "The end date must be later than the start date"
        static let deleteTitle: String = "Delete"
        static let deleteConfirmationTitle: String = "Delete Wish"
        static let deleteConfirmationMessage: String = "Are you sure you want to delete this wish?"
        static let cancelTitle: String = "Cancel"
        static let doneTitle: String = "Done"
        
        static let alertTitle: String = "No desires."
        static let alertMessage: String = "You have no desires yet. Please create one."
    }
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.titlePlaceHolder
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.descriptionPlaceHolder
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    private let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.saveTitle, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.deleteTitle, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var wishes: [Wish] = []
    private let pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    
    var isEditingEvent: Bool = false
    var eventToEdit: WishEvent?
    
    var onSave: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchWishes()
        checkWish()
        configureUI()
        setupDataIfEditing()
        configurePickerView()
    }
    
    private func checkWish() {
        if wishes.isEmpty {
            let alert = UIAlertController(
                title: Constants.alertTitle,
                message: Constants.alertMessage,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Constants.okTitle, style: .cancel, handler: {[weak self] _ in
                self?.cancelPicking()}))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func fetchWishes() {
        wishes = WishDataManager.shared.loadWishes()
    }
    
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        titleTextField.inputView = pickerView
        
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Constants.doneTitle, style: .plain, target: self, action: #selector(donePicking))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        titleTextField.inputAccessoryView = toolbar
        
        if isEditingEvent, let event = eventToEdit, let title = event.title, let index = wishes.firstIndex(where: { $0.text == title }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
            titleTextField.text = title
        }
    }
    
    private func configureUI() {
        var arrangedSubviews: [UIView] = [
            titleTextField,
            descriptionTextField,
            startDatePicker,
            endDatePicker,
            saveButton
        ]
        
        if isEditingEvent {
            arrangedSubviews.append(deleteButton)
        }
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = Constants.stackSpacing
        stackView.alignment = .fill
        
        view.addSubview(stackView)
        stackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.stackPadding)
        stackView.pinLeft(to: view.leadingAnchor, Constants.stackPadding)
        stackView.pinRight(to: view.trailingAnchor, Constants.stackPadding)
    }
    
    private func setupDataIfEditing() {
        if isEditingEvent, let event = eventToEdit {
            titleTextField.text = event.title
            descriptionTextField.text = event.eventDescription
            if let startDate = event.startDate {
                startDatePicker.date = startDate
            }
            if let endDate = event.endDate {
                endDatePicker.date = endDate
            }
            saveButton.setTitle(Constants.updateTitle, for: .normal)
        }
    }
    
    @objc
    private func saveButtonTapped() {
        guard
            let title = titleTextField.text, !title.isEmpty,
            let description = descriptionTextField.text, !description.isEmpty
        else {
            let alert = UIAlertController(title: Constants.errorTitle, message: Constants.fillMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.okTitle, style: .default))
            present(alert, animated: true)
            return
        }
        
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        if endDate < startDate {
            let alert = UIAlertController(title: Constants.errorTitle, message: Constants.dateErrorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.okTitle, style: .default))
            present(alert, animated: true)
            return
        }
        
        if isEditingEvent, let event = eventToEdit {
            WishEventDataManager.shared.editEvent(event, newTitle: title, newDescription: description, newStartDate: startDate, newEndDate: endDate)
        } else {
            WishEventDataManager.shared.addEvent(title: title, description: description, startDate: startDate, endDate: endDate)
        }
        
        let calendarEvent = CalendarEventModel(
            title: title,
            startDate: startDate,
            endDate: endDate,
            note: description
        )
        
        let calendarManager = CalendarManager()
        let success = calendarManager.create(eventModel: calendarEvent)
        
        onSave?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func deleteButtonTapped() {
        guard let event = eventToEdit else { return }
        
        let alert = UIAlertController(
            title: Constants.deleteConfirmationTitle,
            message: Constants.deleteConfirmationMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.cancelTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Constants.deleteTitle, style: .destructive, handler: { _ in
            WishEventDataManager.shared.deleteEvent(event)
            self.onSave?()
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func donePicking() {
        view.endEditing(true)
    }
    
    @objc
    private func cancelPicking() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension WishEventCreationView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wishes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wishes[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        titleTextField.text = wishes[row].text
    }
}
