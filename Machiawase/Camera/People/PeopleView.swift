//
//  People.swift
//  Machiawase
//
//  Created by naru on 2017/03/04.
//  Copyright © 2017年 hazukit. All rights reserved.
//

import UIKit

class PeopleView: UIView {

    struct Constants {
        static let ViewSize: CGSize = CGSize(width: 100.0, height: 100.0)
        static let MarkRadius: CGFloat = 10.0
        static let NameFont: UIFont = UIFont.boldSystemFont(ofSize: 13.0)
        static let Distancefont: UIFont = UIFont.systemFont(ofSize: 12.0)
    }
    
    init(with name: String, identifier: String) {
        
        self.name = name
        self.identifier = identifier
        
        let frame: CGRect = CGRect(origin: .zero, size: Constants.ViewSize)
        super.init(frame: frame)
        
        self.addSubview(self.mark)
        self.addSubview(self.nameLabel)
        self.addSubview(self.distanceLabel)
        
        self.nameLabel.text = self.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: elements
    
    private(set) var name: String
    
    private(set) var identifier: String
    
    /// Point in the window where prigin is center point of the application window
    
    var displayPoint: CGPoint {
        let center: CGPoint = self.center
        return CGPoint(x: UIScreen.main.bounds.width/2.0 - center.x, y: UIScreen.main.bounds.height/2.0 - center.y)
    }
    
    private lazy var mark: UIView = {
        let frame: CGRect = CGRect(origin: .zero, size: CGSize(width: Constants.MarkRadius*2.0, height: Constants.MarkRadius*2.0))
        let view: UIView = UIView(frame: frame)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = Constants.MarkRadius
        view.clipsToBounds = true
        view.center = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let height: CGFloat = ceil(Constants.NameFont.lineHeight)
        let frame: CGRect = CGRect(x: 0.0, y: self.mark.frame.minY - height - 6.0, width: Constants.ViewSize.width, height: height)
        let label: UILabel = UILabel(frame: frame)
        label.font = Constants.NameFont
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let height: CGFloat = ceil(Constants.Distancefont.lineHeight)
        let frame: CGRect = CGRect(x: 0.0, y: self.mark.frame.maxY + 4.0, width: Constants.ViewSize.width, height: height)
        let label: UILabel = UILabel(frame: frame)
        label.font = Constants.Distancefont
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: Control
    
    /// Set view position in display
    /// - parameter displayPoint: center point of the mark contained in this view
    func set(displayPoint: CGPoint) {
        self.center = CGPoint(x: UIScreen.main.bounds.width/2.0 + displayPoint.x, y: UIScreen.main.bounds.height/2.0 + displayPoint.y)
    }
    
    /// Set information of distance.
    /// - parameter distance: distance from this people
    /// - parameter diffrenceOfAltitude: difference of altitude from this people
    func set(distance: Int, diffrenceOfAltitude: Int) {
        
        let text: String
        defer {
            self.distanceLabel.text = text
        }
        
        if diffrenceOfAltitude < 0 {
            text = "\(distance)m ▽\(-diffrenceOfAltitude)m"
        } else if diffrenceOfAltitude > 0 {
            text = "\(distance)m △\(diffrenceOfAltitude)m"
        } else {
            text = "\(distance)m ▷0m"
        }
    }
}
