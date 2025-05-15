extension ExerciseListViewModel {
    
    /// Computes the total number of calories burned today from all exercises.
    /// - Returns: The total calories burned for the current day.
    var calOfDay: Int {
        var total = 0
        for exercise in exercises {
            guard let date = exercise.date else { continue }
            if date.formatted("d MMMM") == Date.now.formatted("d MMMM") {
                total += exercise.calories
            }
        }
        return total
    }
    
    /// Calculates the average duration of exercises within a given date range.
    /// - Parameters:
    ///   - from: The start date of the range. Defaults to `.distantPast`.
    ///   - to: The end date of the range. Defaults to `.now`.
    /// - Returns: The average duration (in minutes) of the exercises during the specified period.
    func averageDuration(from: Date = .distantPast, to: Date = .now) -> Int {
        var total = 0
        var count = 0
        
        for exercise in exercises {
            guard let date = exercise.date else { continue }
            guard date >= from && date <= to else { continue }
            
            total += Int(exercise.duration)
            count += 1
        }
        
        guard count > 0 else { return 0 }
        
        return total / count
    }
    
    /// Determines the trend in average exercise duration over the last week compared to previous data.
    /// - Returns: A string representing the trend:
    ///   - `"chevron.up"` if the average duration has increased significantly.
    ///   - `"chevron.down"` if the average duration has decreased significantly.
    ///   - `"minus"` if the change is not significant.
    func durationTrend() -> String {
        let now = Date.now
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        let recent = averageDuration(from: lastWeek, to: now)
        let older = averageDuration(from: .distantPast, to: lastWeek)
        
        return compareTrend(recent: recent, older: older)
    }
    
    /// Compares two average durations and determines the direction of the trend.
    /// - Parameters:
    ///   - recent: The average duration in the recent period.
    ///   - older: The average duration in the older period.
    /// - Returns: A symbol string indicating the trend direction.
    private func compareTrend(recent: Int, older: Int) -> String {
        let diff = recent - older
        let threshold = 5

        if diff > threshold {
            return "chevron.up"
        } else if diff < -threshold {
            return "chevron.down"
        } else {
            return "minus"
        }
    }
}
