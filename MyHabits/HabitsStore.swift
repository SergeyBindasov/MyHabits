//
//  HabitsStore.swift
//  MyHabits
//
//  Created by Sergey on 03.11.2020.
//  Copyright © 2020 Sergey. All rights reserved.
//

import UIKit

public class Habit: Codable {
    public var name: String
    public var date: Date
    public var trackDates: [Date]
    public var color: UIColor {
        get {
            return.init(red: r, green: g, blue: b, alpha: a)
        }
        set {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            newValue.getRed(&r, green: &g, blue: &b, alpha: &a)
            self.r = r
            self.g = g
            self.b = b
            self.a = a
        }
    }
    
    public var dateString: String {
        "Каждый день в " + dateFormatter.string(from: date)
    }
    
    public var isAlreadyTakenToday: Bool {
        guard let lastTrackDate = trackDates.last else {
            return false
        }
        return calendar.isDateInToday(lastTrackDate)
    }
    
    private var r: CGFloat
    private var g: CGFloat
    private var b: CGFloat
    private var a: CGFloat
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private lazy var calendar: Calendar = .current
    
    public init(name: String, date: Date, trackDates: [Date] = [], color: UIColor) {
        self.name = name
        self.date = date
        self.trackDates = trackDates
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

extension Habit: Equatable {
    public static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.name == rhs.name &&
        lhs.date == rhs.date &&
        lhs.trackDates == rhs.trackDates &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.a == rhs.a
    }
}

public class HabitStore {
    
    public static let shared: HabitStore = .init()
    
    public var habits: [Habit] = [] {
        didSet {
            save()
        }
    }
    
    public var dates: [Date] {
        guard let startDate = userDefaults.object(forKey: "start_date") as? Date else {
            return []
        }
        return Date.dates(from: startDate, to: .init())
    }
    
    public var todayProgress: Float {
        guard habits.isEmpty == false else {
            return 0
        }
        let takenTodayHabits = habits.filter {$0.isAlreadyTakenToday}
        return Float(takenTodayHabits.count) / Float(habits.count)
    }
    
    private lazy var userDefaults: UserDefaults = .standard
    
    private lazy var decoder: JSONDecoder = .init()
    
    private lazy var encoder: JSONEncoder = .init()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private lazy var calendar: Calendar = .current
    
    public func track(_ habit: Habit) {
        habit.trackDates.append(.init())
        save()
    }
    
    public func trackDateString(forIndex index: Int) -> String? {
        guard index > dates.count else {
            return nil
        }
        return dateFormatter.string(from: dates[index])
    }
    
    public func habit(_ habit: Habit, isTrackedIn date: Date) -> Bool {
        habit.trackDates.contains { trackDate in
            guard let trackDateDay = calendar.dateComponents([.day], from: trackDate).day else {
                return false
            }
            guard let dateDay = calendar.dateComponents([.day], from: date).day else {
                return false
            }
            return trackDateDay - dateDay == 0
        }
    }
    
    public func save() {
        do {
            let data = try encoder.encode(habits)
            userDefaults.setValue(data, forKey: "habits")
        }
        catch {
            print("Ошибка кодирования привычек для сохранения", error)
        }

    }
    
    private init() {
        if userDefaults.value(forKey: "start_date") == nil {
            userDefaults.setValue(Date(), forKey: "start_date")
        }
        guard let data = userDefaults.data(forKey: "habits") else {
            return
        }
        do {
            habits = try decoder.decode([Habit].self, from: data)
        }
        catch {
            print("Ошибка декодирования сохранённых привычек", error)
        }
    }
}


private extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
                break
            }
            date = newDate
        }
        return dates
    }
}

