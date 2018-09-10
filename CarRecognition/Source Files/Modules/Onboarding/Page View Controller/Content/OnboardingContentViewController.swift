//
//  OnboardingViewController.swift
//  CarRecognition
//


import UIKit

// Intefrace for notifying parent view controller about current page
protocol OnboardingContentPresentable: class {
    
    /// Notify about current page
    ///
    /// - Parameter type: Type of current page.
    func willPresentControllerWithType(_ type: OnboardingContentViewController.ContentType)
}

internal final class OnboardingContentViewController: TypedViewController<OnboardingContentView> {
    
    /// Delegate used to inform about current page
    weak var delegate: OnboardingContentPresentable?
    
    private var type: ContentType
    
    enum ContentType: Int {
        case first
        case second
        case third
    
        var title: String {
            switch self {
            case .first:
                return Localizable.Onboarding.Title.first
            case .second:
                return Localizable.Onboarding.Title.second
            case .third:
                return Localizable.Onboarding.Title.third
            }
        }
        
        var info: String {
            switch self {
            case .first:
                return Localizable.Onboarding.Description.first
            case .second:
                return Localizable.Onboarding.Description.second
            case .third:
                return Localizable.Onboarding.Description.third
            }
        }
    }

    init(type: ContentType) {
        self.type = type
        super.init(viewMaker: OnboardingContentView())
        customView.setup(with: type.title, infoText: type.info)
    }

    /// SeeAlso: UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.willPresentControllerWithType(type)
    }
}
