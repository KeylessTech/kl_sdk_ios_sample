import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ButtonStatus(
                text: "Setup", action: viewModel.setup,
                disabled: !viewModel.uiButtonState.setup,
                apiState: viewModel.uiIndicatorState.setup
            )

            ButtonStatus(
                text: "Enroll", action: viewModel.enroll,
                disabled: !viewModel.uiButtonState.enroll,
                apiState: viewModel.uiIndicatorState.enroll
            )

            ButtonStatus(
                text: "Authenticate", action: viewModel.authenticate,
                disabled: !viewModel.uiButtonState.auth,
                apiState: viewModel.uiIndicatorState.auth
            )

            ButtonStatus(
                text: "DeEnroll", action: viewModel.deEnroll,
                disabled: !viewModel.uiButtonState.deEnroll,
                apiState: viewModel.uiIndicatorState.deEnroll
            )

            ButtonStatus(
                text: "Reset", action: viewModel.reset,
                disabled: false,
                apiState: .idle
            )

        }
    }
}

struct ButtonStatus: View {
    let text: String
    let action: () -> Void
    let disabled: Bool
    let apiState: ApiState

    var body: some View {
        HStack(spacing: 8) {
            Button(action: action) {
                Text(text)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 23 / 255, green: 52 / 255, blue: 184 / 255))
            .cornerRadius(100)
            .disabled(disabled)

            switch apiState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .frame(width: 16, height: 16)
            case .success:
                Circle()
                    .fill(Color.green)
                    .frame(width: 16, height: 16)
            case .error:
                Circle()
                    .fill(Color.red)
                    .frame(width: 16, height: 16)
            }
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
