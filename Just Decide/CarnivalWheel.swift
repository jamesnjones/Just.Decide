//
//  CarnivalWheel.swift
//  Just Decide
//
//  Created by James Jones on 10/07/2020.
//  Copyright © 2020 James Jones. All rights reserved.
//

import UIKit
import TTFortuneWheel

class CarnivalWheel: FortuneWheelSliceProtocol, Codable, Hashable {
    
    static func == (lhs: CarnivalWheel, rhs: CarnivalWheel) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    enum Style: String, Codable, Hashable {
             case blue
             case purple
             case green
             case grey
             case orange
             case yellow
             
         }
         var style: Style = .blue
         var backgroundColor: UIColor? {
                   
               switch style {
               case .blue: return TTUtils.uiColor(from: 0xdff9fb)
               case .purple: return TTUtils.uiColor(from: 0xa29bfe)
               case .green: return TTUtils.uiColor(from: 0x7bed9f)
               case . grey: return TTUtils.uiColor(from: 0xdfe4ea)
               case .orange: return TTUtils.uiColor(from: 0xffbe76)
               case .yellow: return TTUtils.uiColor(from: 0xf6e58d)
               }
           }
  
        var title: String
        var degree: CGFloat = 0.0
        
    
    
    init(title: String) {
      self.title = title
    }
    
      
    
        var fontColor: UIColor {
        return UIColor.black
    }


        var offsetFromExterior: CGFloat {
        return 10.0
        
    }
    
        var stroke: StrokeInfo? {
        return StrokeInfo(color: UIColor.white, width: 1.0)
    }
    
    
    
    
    convenience init(title: String, degree: CGFloat) {
        self.init(title: title)
        self.degree = degree
    }
    

}
