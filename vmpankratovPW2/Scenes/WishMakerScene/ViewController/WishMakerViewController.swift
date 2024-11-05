//
//  WishMakerViewController.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 28.10.2024.
//

import UIKit

// MARK: - WishMakerViewController
final class WishMakerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constans
    internal let interactor: BusinessLogic
    internal let interfaceView = UIView()
    internal let labelView = UIView()
    internal let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    internal let colorChangesStack = UIStackView()
    internal let inputField = UITextField()
    internal let hideButton = UIButton()
    internal let mainTitle = UILabel()
    internal let descriptionLabel = UILabel()
    
    // MARK: - Variebles
    internal var customKeyboard: CustomKeyboardView?
    internal var sliders = [CustomSlider]()
    internal var isHidden: Bool = false
    internal var segmentControl: CustomSegmentedControl!
    
    // MARK: - Initialization
    init(interactor: BusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDismissKeyboardGesture()
        setupKeyboardNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeOrientation),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        deleteConstraints()
        updateLayout(for: size)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = UIColor.random()
        configureLabelView()
        configureInterfaceView()
        configureZStack()
        configureTitle()
        configureDescription()
        configureSlider()
        configureHEXInput()
        configureRandomButton()
        configureSegmentedControl()
        configureHideButton()
        
        hideAllSubviews()
        showSubview(at: 0)
    }
    
    // MARK: - Subview Visibility
    internal func hideAllSubviews() {
        for subview in colorChangesStack.arrangedSubviews {
            subview.isHidden = true
        }
    }
    
    internal func showSubview(at index: Int) {
        guard index < colorChangesStack.arrangedSubviews.count else { return }
        colorChangesStack.arrangedSubviews[index].isHidden = false
    }
    
    // MARK: - Keyboard Dismissal Setup
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        
        if isHidden {
            isHidden.toggle()
            view.subviews.forEach { $0.isHidden = false }
            
            UIView.animate(withDuration: Constants.animateDuration) {
                self.view.subviews.forEach { $0.alpha = 1 }
            }
        }
    }
    
    // MARK: - Orientation Change Handling
    @objc private func didChangeOrientation() {
        deleteConstraints()
        updateLayout(for: view.bounds.size)
    }
}
