//
//  UserStatsController.swift
//  BWM
//
//  Created by Serhii on 10/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Flurry_iOS_SDK

class UserStatsController: UIViewController, UserProfileTabController {

    //MARK: - Outlets
    @IBOutlet private weak var viewContent: UIView!
    
    @IBOutlet private weak var circleViewed: UICircularProgressRing!
    @IBOutlet private weak var blobViewed: UICircularProgressRing!
    
    @IBOutlet private weak var circleInterviewed: UICircularProgressRing!
    @IBOutlet private weak var blobInterviewed: UICircularProgressRing!
    
    @IBOutlet private weak var circleHired: UICircularProgressRing!
    @IBOutlet private weak var blobHired: UICircularProgressRing!
    
    @IBOutlet private weak var labelViewed: UILabel!
    @IBOutlet private weak var labelInterviewed: UILabel!
    @IBOutlet private weak var labelHired: UILabel!
    
    @IBOutlet private weak var fullnessLabel: UILabel!
    @IBOutlet private weak var fullnessView: UIProgressView!
    
    @IBOutlet private weak var profileGraphView: ScrollableGraphView!
    @IBOutlet private weak var messageGraphView: ScrollableGraphView!
    @IBOutlet private weak var initialGraphView: ScrollableGraphView!
    
    @IBOutlet private weak var viewSelector: SelectorComponent!
    
    var user: AuthObject!
    
    //MARK: - Tab controller
    var tabType: UserProfileTabType {
        return .statistics
    }
    
    weak var delegate: UserProfileTabControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileGraphView.dataSource = self
        messageGraphView.dataSource = self
        initialGraphView.dataSource = self
        
        self.viewSelector.updateWithButtons(buttonTitles: ["profile", "message", "initial"])
        self.viewSelector.delegate = self
        
        setupUI()
        
        setupGraph(graphView: profileGraphView)
        setupGraph(graphView: messageGraphView)
        setupGraph(graphView: initialGraphView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PurchaseUtils.shared.checkOnScreen(self, sCase: .statistic)
        Flurry.logEvent("UserProfileScreen_statistics")
        self.changedContentHeight()
    }
    
    //MARK: - Private methods
    
    fileprivate func changedContentHeight() {
        let height = self.viewContent.frame.size.height
        self.delegate?.didChangeContentHeight(height)
    }
    
    private func setupUI() {
        self.fullnessView.setProgress(Float((Double(user.fullness)/100.0)), animated: true)
        self.fullnessLabel.text = "\(user.fullness)%"
        
        setupCircles()
        setupCircleLabels()
    }
    
    private func setupCircleLabels() {
        let profileDiff = user.profilePro - user.profile
        if profileDiff > 25 {
            self.labelViewed.text = "Less often"
        }
        else if profileDiff <= 25 && profileDiff > -25 {
            self.labelViewed.text = "Average"
        }
        else {
            self.labelViewed.text = "More often"
        }
        
        let messageDiff = user.messagePro - user.message
        if messageDiff > 25 {
            self.labelInterviewed.text = "Less often"
        }
        else if messageDiff <= 25 && messageDiff > -25 {
            self.labelInterviewed.text = "Average"
        }
        else {
            self.labelInterviewed.text = "More often"
        }
        
        let searchDiff = user.searchPro - user.search
        if searchDiff > 25 {
            self.labelHired.text = "Less often"
        }
        else if searchDiff <= 25 && searchDiff > -25 {
            self.labelHired.text = "Average"
        }
        else {
            self.labelHired.text = "More often"
        }
    }
    
    private func setupCircles() {
        let circles: [UICircularProgressRing] = [circleViewed, circleInterviewed, circleHired]
        let blobs: [UICircularProgressRing] = [blobViewed, blobInterviewed, blobHired]
        
        for circle in circles {
            circle.ringStyle = .gradient
            circle.outerRingColor = .lightGray
            circle.outerRingWidth = circle.innerRingWidth - 1.5
            circle.startAngle = 270.0
            circle.minValue = 0
            circle.maxValue = 365
            circle.gradientColors = [UIColor(255,118,40), UIColor(224,38,123), UIColor(208,49,152), UIColor(255,70,70)]
            circle.shouldShowValueText = false
        }
        
        circleViewed.startProgress(to: UICircularProgressRing.ProgressValue(user.profilePro), duration: 5.0)
        circleInterviewed.startProgress(to: UICircularProgressRing.ProgressValue(user.messagePro), duration: 5.0)
        circleHired.startProgress(to: UICircularProgressRing.ProgressValue(user.searchPro), duration: 5.0)
        
        for blob in blobs {
            blob.ringStyle = .ontop
            blob.outerRingColor = .clear
            blob.startAngle = 270.0
            blob.innerRingColor = .clear
            blob.innerRingWidth = circleViewed.innerRingWidth
            blob.outerRingWidth = blob.innerRingWidth
            blob.valueKnobColor = .appRed
            blob.showsValueKnob = true
            blob.valueKnobSize = 10.0
            blob.shouldShowValueText = false
            blob.minValue = 0
            blob.maxValue = 365
        }
        
        blobViewed.startProgress(to: UICircularProgressRing.ProgressValue(user.profile), duration: 0.0)
        blobInterviewed.startProgress(to: UICircularProgressRing.ProgressValue(user.message), duration: 0.0)
        blobHired.startProgress(to: UICircularProgressRing.ProgressValue(user.search), duration: 0.0)
    }
}

extension UserStatsController: SelectorComponentViewDelegate {
    func selectedButtonWithIndex(_ index: Int) {
        /*self.profileGraphView.isHidden = index != 0
        self.messageGraphView.isHidden = index != 1
        self.messageGraphView.isHidden = index != 2*/
        if index == 0 {
            viewContent.bringSubview(toFront: profileGraphView)
        }
        else if index == 1 {
            viewContent.bringSubview(toFront: messageGraphView)
        }
        else if index == 2 {
            viewContent.bringSubview(toFront: initialGraphView)
        }
    }
}

extension UserStatsController: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if let stats = GraphStatsStore.shared.stats {
            switch(plot.identifier) {
            case "profileOne", "profileTwo":
                return Double(stats[pointIndex].profile ?? 0)
                //return Double.random(in: 0..<100)
            case "messageOne", "messageTwo":
                return Double(stats[pointIndex].message ?? 0)
            case "initialOne", "initialTwo":
                return Double(stats[pointIndex].search ?? 0)
            default:
                return 0
            }
        }
        
        return 0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        if pointIndex%2 != 0 {
            return ""
        }
        guard let dateString = GraphStatsStore.shared.stats?[pointIndex].date else {return ""}
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"
        
        if let date = dateFormatterGet.date(from: dateString){
            return dateFormatterPrint.string(from: date).uppercased()
        } else {
            print("There was an error decoding the string")
        }
        
        return ""
    }
    
    func numberOfPoints() -> Int {
        return GraphStatsStore.shared.stats?.count ?? 0
    }
    
    func setupGraph(graphView: ScrollableGraphView) {
        if graphView == profileGraphView {
            let referenceLines = ReferenceLines()
            referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            referenceLines.referenceLineColor = UIColor.clear
            referenceLines.referenceLineLabelColor = UIColor.clear
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)
            
            let linePlot = LinePlot(identifier: "profileOne")
            linePlot.lineWidth = 4
            linePlot.lineColor = UIColor.red
            linePlot.lineStyle = ScrollableGraphViewLineStyle.straight
            linePlot.shouldFill = true
            linePlot.fillType = ScrollableGraphViewFillType.gradient
            linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
            linePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#F63B6E")
            linePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#FF544A")
            
            let dotPlot = DotPlot(identifier: "profileTwo")
            dotPlot.dataPointSize = 0.0
            dotPlot.dataPointFillColor = UIColor.red
            
            dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            dotPlot.labelFont = UIFont.systemFont(ofSize: 14)
            dotPlot.labelColor = UIColor.clear
            dotPlot.labelVerticalOffset = -30.0
            
            profileGraphView.backgroundFillColor = UIColor.white
            profileGraphView.dataPointSpacing = 60
            profileGraphView.rightmostPointPadding = UIScreen.main.bounds.width / 2
            profileGraphView.direction = ScrollableGraphViewDirection.rightToLeft
            profileGraphView.rangeMin = 0
            profileGraphView.rangeMax = Double(GraphStatsStore.shared.searchMax)
            profileGraphView.topMargin = 80
            
            profileGraphView.shouldAnimateOnStartup = true
            profileGraphView.shouldAdaptRange = false
            profileGraphView.shouldRangeAlwaysStartAtZero = false
            
            profileGraphView.addReferenceLines(referenceLines: referenceLines)
            profileGraphView.addPlot(plot: linePlot)
            profileGraphView.addPlot(plot: dotPlot)
        }
        
        if graphView == messageGraphView {
            let referenceLines = ReferenceLines()
            referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            referenceLines.referenceLineColor = UIColor.clear
            referenceLines.referenceLineLabelColor = UIColor.clear
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)
            
            let linePlot = LinePlot(identifier: "messageOne")
            linePlot.lineWidth = 4
            linePlot.lineColor = UIColor.red
            linePlot.lineStyle = ScrollableGraphViewLineStyle.straight
            linePlot.shouldFill = true
            linePlot.fillType = ScrollableGraphViewFillType.gradient
            linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
            linePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#F63B6E")
            linePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#FF544A")
            
            let dotPlot = DotPlot(identifier: "messageTwo")
            dotPlot.dataPointSize = 0.0
            dotPlot.dataPointFillColor = UIColor.red
            dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            dotPlot.labelFont = UIFont.systemFont(ofSize: 14)
            dotPlot.labelColor = UIColor.clear
            dotPlot.labelVerticalOffset = -30.0
            
            messageGraphView.backgroundFillColor = UIColor.white
            messageGraphView.dataPointSpacing = 60
            messageGraphView.rightmostPointPadding = UIScreen.main.bounds.width / 2
            messageGraphView.direction = ScrollableGraphViewDirection.rightToLeft
            messageGraphView.rangeMin = 0
            messageGraphView.rangeMax = Double(GraphStatsStore.shared.searchMax)
            messageGraphView.topMargin = 80
            
            messageGraphView.shouldAnimateOnStartup = true
            messageGraphView.shouldAdaptRange = false
            messageGraphView.shouldRangeAlwaysStartAtZero = false
            
            messageGraphView.addReferenceLines(referenceLines: referenceLines)
            messageGraphView.addPlot(plot: linePlot)
            messageGraphView.addPlot(plot: dotPlot)
        }
        
        if graphView == initialGraphView {
            let referenceLines = ReferenceLines()
            referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            referenceLines.referenceLineColor = UIColor.clear
            referenceLines.referenceLineLabelColor = UIColor.clear
            referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)
            
            let linePlot = LinePlot(identifier: "initialOne")
            linePlot.lineWidth = 4
            linePlot.lineColor = UIColor.red
            linePlot.lineStyle = ScrollableGraphViewLineStyle.straight
            linePlot.shouldFill = true
            linePlot.fillType = ScrollableGraphViewFillType.gradient
            linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
            linePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#F63B6E")
            linePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#FF544A")
            
            let dotPlot = DotPlot(identifier: "initialTwo")
            dotPlot.dataPointSize = 0.0
            dotPlot.dataPointFillColor = UIColor.red
            dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
            dotPlot.labelFont = UIFont.systemFont(ofSize: 14)
            dotPlot.labelColor = UIColor.clear
            dotPlot.labelVerticalOffset = -30.0
            
            initialGraphView.backgroundFillColor = UIColor.white
            initialGraphView.dataPointSpacing = 60
            initialGraphView.rightmostPointPadding = UIScreen.main.bounds.width / 2
            initialGraphView.direction = ScrollableGraphViewDirection.rightToLeft
            initialGraphView.rangeMin = 0
            initialGraphView.rangeMax = Double(GraphStatsStore.shared.searchMax)
            initialGraphView.topMargin = 80
            
            initialGraphView.shouldAnimateOnStartup = true
            initialGraphView.shouldAdaptRange = false
            initialGraphView.shouldRangeAlwaysStartAtZero = false
            
            initialGraphView.addReferenceLines(referenceLines: referenceLines)
            initialGraphView.addPlot(plot: linePlot)
            initialGraphView.addPlot(plot: dotPlot)
        }
    }
    
    func plotLabel(shouldShowPlotLabel plot: Plot, atIndex pointIndex: Int) -> Bool {
        return true
    }
    
    func plotLabel(forPlot plot: Plot, atIndex pointIndex: Int) -> String? {
        if let stats = GraphStatsStore.shared.stats {
            switch(plot.identifier) {
            case "profileTwo":
                return (stats[pointIndex].profile ?? 0).roundedString
            case "messageTwo":
                return (stats[pointIndex].message ?? 0).roundedString
            case "initialTwo":
                return (stats[pointIndex].search ?? 0).roundedString
            default:
                return ""
            }
        }
        
        return ""
    }
    
}
