//
//  HorizontalProgressChartView.swift
//  CarRecognition
//


import UIKit
import Lottie

internal final class HorizontalProgressChartView: View, ViewSetupable {
    
    /// States avilable to display by this view
    enum State {
        case power(Int)
        case engine(Int)
    }
    
    private let state: State
    
    private let chartConfig = CarSpecificationChartConfiguration()
    
    private lazy var animationView = LOTAnimationView(name: "horizontal-progress-chart").layoutable()
    
    private lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.font = .gliscorGothicFont(ofSize: 20)
        view.textColor = .crFontDark
        view.numberOfLines = 1
        view.textAlignment = .left
        return view.layoutable()
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .gliscorGothicFont(ofSize: 12)
        view.textColor = .crFontGray
        view.numberOfLines = 1
        view.textAlignment = .left
        return view.layoutable()
    }()
    
    /// Initializes the view with given state
    ///
    /// - Parameters:
    ///   - state: State to bet shown by the biew
    ///   - invalidateChartInstantly: Chart will be updated instantly without animation if this value indicates false.
    ///                               When passing false, remember to use method `invalidatChart(animated:)` also
    init(state: State, invalidateChartInstantly: Bool) {
        self.state = state
        super.init()
        
        switch state {
        case .power(let power):
            let valueText = String(power)
            valueLabel.attributedText = NSAttributedStringFactory.trackingApplied(valueText, font: valueLabel.font, tracking: 0.6)
            titleLabel.text = Localizable.CarCard.power.uppercased()
        case .engine(let engine):
            let valueText = "\(engine) \(Localizable.CarCard.hp)"
            valueLabel.attributedText = NSAttributedStringFactory.trackingApplied(valueText, font: valueLabel.font, tracking: 0.6)
            titleLabel.text = Localizable.CarCard.engine.uppercased()
        }
        if invalidateChartInstantly {
            invalidateChart(animated: false)
        }
    }
    
    /// Invalidates the progress shown on the chart
    ///
    /// - Parameter animated: Indicating if invalidation should be animated
    func invalidateChart(animated: Bool) {
        let progress: Double
        switch state {
        case .power(let power):
            progress = Double(power) / Double(chartConfig.referenceHorsePower)
        case .engine(let engine):
            progress = Double(engine) / Double(chartConfig.referenceEngineVolume)
        }
        if animated {
            animationView.play(toProgress: CGFloat(progress))
        } else {
            animationView.animationProgress = CGFloat(progress)
        }
    }
    
    /// - SeeAlso: ViewSetupable
    func setupViewHierarchy() {
        [animationView, valueLabel, titleLabel].forEach(addSubview)
    }
    
    /// - SeeAlso: ViewSetupable
    func setupConstraints() {
        titleLabel.constraintToSuperviewEdges(excludingAnchors: [.bottom])
        valueLabel.constraintToSuperviewEdges(excludingAnchors: [.top, .bottom])
        animationView.constraintToSuperviewEdges(excludingAnchors: [.top])
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: animationView.topAnchor, constant: 3),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -3)
        ])
    }
    
    /// - SeeAlso: ViewSetupable
    func setupProperties() {
        animationView.loopAnimation = true
        animationView.play(toProgress: 1.0, withCompletion: nil)
        
        // TODO: For debuging purposes. Remove when lottie will be fully working
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
}
