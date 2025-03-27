import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var enrollDisabled: Bool = true
    @Published var authenticateDisabled: Bool = true
    @Published var deenrollDisabled: Bool = true

    let keylessWrapper = KeylessWrapper()

    // Make sure you followed the README.md to add your API Key and Host into the Info.plist
    private let apikey: String = Configuration.apiKey
    private let hosts = [Configuration.host]

    @Published private(set) var uiButtonState: EnabledButtonState = .init()
    @Published private(set) var uiIndicatorState: IndicatorState = .init()

    func setup() {
        Task { [weak self] in

            guard let key = self?.apikey else {
                print("Keyless setup error: apiKey is nil")
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: .error)
                )
                return
            }

            guard let hostsList = self?.hosts else {
                print("Keyless setup error: hosts is nil")
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: .error)
                )
                return
            }

            do {
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: .loading)
                )
                try await self?.keylessWrapper.setup(
                    apiKey: key, hosts: hostsList)
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: .success)
                )
                await self?.checkEnroll()
            } catch let error {
                print("Keyless setup error.\n\(error)")
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: .error)
                )

            }
        }
    }

    func updateIndicatorState(indicatorState: IndicatorState) async {
        await MainActor.run {
            self.uiIndicatorState = indicatorState
        }
    }

    func checkEnroll() async {
        do {
            _ = try await self.keylessWrapper.isUserAndDeviceActive()
            await MainActor.run {
                self.uiButtonState = EnabledButtonState(
                    setup: true, enroll: false, auth: true, deEnroll: true)
            }
            print("Keyless isUserAndDeviceActive success")
        } catch let error {
            await MainActor.run {
                self.uiButtonState = EnabledButtonState(
                    setup: true, enroll: true, auth: false, deEnroll: false)
            }
            print("Keyless isUserAndDeviceActive error.\n\(error)")
        }

    }

    func enroll() {
        Task { [weak self] in
            do {
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, enroll: .loading)
                )
                
                try await self?.keylessWrapper.enroll()
                await self?.checkEnroll()

                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, enroll: .success)
                )
            } catch let error {
                print("Keyless enroll error.\n\(error)")
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, enroll: .error)
                )

            }
        }
    }

    func authenticate() {
        Task { [weak self] in
            do {
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, auth: .loading)
                )
                
                try await self?.keylessWrapper.authenticate()
                await self?.checkEnroll()

                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, auth: .success)
                )

            } catch let error {
                print("Keyless authenticate error.\n\(error)")
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, auth: .error)
                )

            }
        }
    }

    func deEnroll() {
        Task { [weak self] in
            do {
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, deEnroll: .loading)
                )
                
                try await self?.keylessWrapper.deEnroll()
                await self?.checkEnroll()

                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, deEnroll: .success)
                )
            } catch let error {
                print("Keyless authenticate error.\n\(error)")
                await self?.updateIndicatorState(
                    indicatorState: IndicatorState(setup: self?.uiIndicatorState.setup ?? .idle, deEnroll: .error)
                )

            }
        }
    }

    func reset() {
        keylessWrapper.reset()
        
        Task { [weak self] in
            await self?.checkEnroll()
            await self?.updateIndicatorState(
                indicatorState: IndicatorState()
            )
        }
    }
}
