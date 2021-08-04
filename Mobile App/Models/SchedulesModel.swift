//
//  SchedulesModel.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation

struct SchedulesModel: Codable {
    var monday: ScheduleModel?
    var tuesday: ScheduleModel?
    var wednesday: ScheduleModel?
    var thursday: ScheduleModel?
    var friday: ScheduleModel?
    var saturday: ScheduleModel?
    var sunday: ScheduleModel?
}
