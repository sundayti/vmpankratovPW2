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
    
    var isEditingEvent: Bool = false
    var eventToEdit: WishEvent?
    
    var onSave: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setupDataIfEditing()
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [
            titleTextField,
            descriptionTextField,
            startDatePicker,
            endDatePicker,
            saveButton
        ])
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
            // Создание нового события
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
}
