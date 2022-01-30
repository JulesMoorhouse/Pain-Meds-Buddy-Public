//
//  DurationPicker.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct DurationPicker: UIViewRepresentable {
    @Binding var duration: String

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateDuration),
            for: .valueChanged
        )
        return datePicker
    }

    func updateUIView(_ datePicker: UIDatePicker, context _: Context) {
        datePicker.countDownDuration = TimeInterval(Int(duration) ?? 0)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: DurationPicker

        init(_ parent: DurationPicker) {
            self.parent = parent
        }

        @objc func updateDuration(datePicker: UIDatePicker) {
            parent.duration = "\(Int(datePicker.countDownDuration))"
        }
    }
}

struct DurationPicker_Previews: PreviewProvider {
    static var previews: some View {
        DurationPicker(duration: .constant("30"))
    }
}
