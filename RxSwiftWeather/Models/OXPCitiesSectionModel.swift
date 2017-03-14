//
//  OXPCitiesSectionModel.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/14.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import RxDataSources

struct OXPCitiesSectionModel {
    var items: [Item]
}

extension OXPCitiesSectionModel : AnimatableSectionModelType {
    typealias Item = OXPThinkpageCityModel
    
    var identity: String {
        return "OXPCitiesSection"
    }
    
    init(original: OXPCitiesSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
