//
//  WishMakerViewController+UpdateLayout.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 05.11.2024.
//

import UIKit

extension WishMakerViewController {
    // MARK: - Layout Update Methods
    internal func updateLayout(for size: CGSize) {
        if size.width > size.height {
            applyLandscapeLayout()
        } else {
            applyPortraitLayout()
        }
        hideAllSubviews()
        if segmentControl.getIndex() < 0 {
            segmentControl.setIndex(to: 0)
        }
        showSubview(at: segmentControl.getIndex())
    }
    
    private func applyLandscapeLayout() {
        if colorChangesStack.arrangedSubviews.count == Constants.numberOfOptions {
            removeSecondSubviewFromZStack()
            segmentControl.removeSegment(at: 1)
        }
        
        interfaceView.pinCenterY(to: view)
        interfaceView.pinRight(to: view.centerXAnchor, Constants.interfaceViewRighAtHorizontal)
        interfaceView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor)
        
        
        labelView.pinCenterY(to: view)
        labelView.pinLeft(to: view.centerXAnchor, Constants.labelViewLeftAtHorizontal)
        labelView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    private func applyPortraitLayout() {
        if colorChangesStack.arrangedSubviews.count == Constants.numberOfOptions - 1 {
            removeSecondSubviewFromZStack()
            configureHEXInput()
            configureRandomButton()
            colorChangesStack.arrangedSubviews[1].isHidden = true
            segmentControl.insertSegment(withTitle: SegmentedControlConstants.secondTitle, at: 1)
        }
        
        interfaceView.pinBottom(to: view.bottomAnchor, -Constants.interfaceViewBottom)
        interfaceView.pinHorizontalEdges(to: view)
        
        labelView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.labelViewTop)
        labelView.pinHorizontalEdges(to: view)
    }
    
    // MARK: - Constraint Deletion Method
    internal func deleteConstraints() {
        view.constraints.forEach { constraint in
            if isRelatedToView(constraint, interfaceView) || isRelatedToView(constraint, labelView) {
                view.removeConstraint(constraint)
            }
        }
        reapplyConstraints()
    }
    
    private func isRelatedToView(_ constraint: NSLayoutConstraint, _ targetView: UIView) -> Bool {
        return constraint.firstItem as? UIView == targetView || constraint.secondItem as? UIView == targetView
    }
    
    private func reapplyConstraints() {
        hideButton.pinLeft(to: interfaceView.leadingAnchor, Constants.hideButtonLeft)
        segmentControl.pinHorizontal(to: interfaceView, Constants.pinHorizontal)
        colorChangesStack.pinCenterX(to: interfaceView)
        colorChangesStack.pinHorizontal(to: interfaceView, Constants.pinHorizontal)
        hideButton.pinTop(to: interfaceView.topAnchor)
        mainTitle.pinCenterX(to: labelView)
        mainTitle.pinTop(to: labelView.topAnchor)
        descriptionLabel.pinTop(to: mainTitle.bottomAnchor, Constants.descriptionTop)
        descriptionLabel.pinHorizontal(to: labelView, Constants.pinHorizontal)
        descriptionLabel.pinBottom(to: labelView.bottomAnchor)
    }
    
    // MARK: - Helper Methods
    private func removeSecondSubviewFromZStack() {
        let secondView = colorChangesStack.arrangedSubviews[1]
        colorChangesStack.removeArrangedSubview(secondView)
        secondView.removeFromSuperview()
    }
}
