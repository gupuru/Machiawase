//
//  PeopleManager.swift
//  Machiawase
//
//  Created by naru on 2017/03/04.
//  Copyright © 2017年 hazukit. All rights reserved.
//

import UIKit

struct PeopleLocation {
    let identifier: String
    let name: String
    let x: CGFloat
    let y: CGFloat
    let distance: Int
    let differenceOfAltitude: Int
}

class PeopleManager {
    
    init(with managedView: UIView) {
        self.managedView = managedView
    }
    
    weak var managedView: UIView?
    
    private(set) var peopleViews: [PeopleView] = []
    
    private func peopleView(with identifier: String) -> PeopleView? {
        return self.peopleViews.filter { $0.identifier == identifier }.first
    }
    
    /// Update people view with location infomations.
    /// People view will be automatically added on view and removed from super view.
    /// - parameter locations: Location infomations to update people views
    func update(with locations: [PeopleLocation]) {
        
        guard let managedView = self.managedView else {
            return
        }
        
        // Check to create new people view
        for location in locations {
            let count: Int = self.peopleViews.filter { $0.identifier == location.identifier }.count
            if count == 0 {
                // Create new people view
                let peopleView: PeopleView = PeopleView(with: location.name, identifier: location.identifier)
                managedView.addSubview(peopleView)
                self.peopleViews.append(peopleView)
            }
        }
        
        // Check to remove unused people view
        for peopleView in self.peopleViews {
            let count: Int = locations.filter { $0.identifier == peopleView.identifier }.count
            if count == 0 {
                peopleView.removeFromSuperview()
                if let index: Int = self.peopleViews.index(of: peopleView) {
                    self.peopleViews.remove(at: index)
                }
            }
        }
        
        // Update each view
        for location in locations {
            if let peopleView = self.peopleView(with: location.identifier) {
                peopleView.set(displayPoint: CGPoint(x: location.x, y: location.y))
                peopleView.set(distance: location.distance, diffrenceOfAltitude: location.differenceOfAltitude)
            }
        }
    }
}
