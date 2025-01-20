import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue) // Fill color for the button
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2) // Outline with white color and 2pt width
            )
            .foregroundColor(.white) // Text color
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Slight scaling when pressed
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct CustomButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button(action: {
                print("Primary Button Tapped!")
            }) {
                Text("Primary Button")
            }
            .buttonStyle(CustomButtonStyle()) // Apply the custom button style

            Button(action: {
                print("Secondary Button Tapped!")
            }) {
                Text("Secondary Button")
            }
            .buttonStyle(CustomButtonStyle()) // Apply the custom button style
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
