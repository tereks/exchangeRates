//
//  TimerService.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

public final class TimerService: Observable {

    public var observations: [UUID: SimpleAction] = [:]
    public var secondsObservations: [UUID: IntAction] = [:]

    public var isRunning: Bool {
        return currencyUpdateTimer != nil
    }

    private var lastUpdateDate: Date?
    private var secondsLeft: Int = -1
    private var currencyUpdateTimer: Timer?

    @discardableResult
    public func observeChange(using closure: @escaping SimpleAction) -> ObservationToken {
        let id = observations.insert(closure)

        return ObservationToken { [weak self] in
            guard let self = self else { return }
            self.observations.removeValue(forKey: id)
        }
    }

    @discardableResult
    public func observeSecondsChange(using closure: @escaping IntAction) -> IntObservationToken {
        let id = secondsObservations.insert(closure)

        return IntObservationToken { [weak self] _ in
            self?.secondsObservations.removeValue(forKey: id)
        }
    }

    public func start(updateInterval: TimeInterval, lastUpdateDate: Date) {
        debugPrint("Timer start with interval = \(updateInterval)")
        self.lastUpdateDate = lastUpdateDate
        self.secondsLeft    = Int(updateInterval)
        currencyUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.secondsLeft -= 1
            guard self.secondsLeft > 0 else {
                self.notifyTimerDidChanged()
                self.reset()
                return
            }
            self.notifySecondDidPass()
        }
    }

    public func reset() {
        debugPrint("Timer reset")
        currencyUpdateTimer?.invalidate()
        currencyUpdateTimer = nil
    }

    private func notifySecondDidPass() {
        debugPrint("Seconds left \(secondsLeft)")
        secondsObservations.values.forEach { handler in
            handler(secondsLeft)
        }
    }

    private func notifyTimerDidChanged() {
        observations.values.forEach { handler in
            handler()
        }
    }
}
