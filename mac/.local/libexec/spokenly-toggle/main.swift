import AppKit
import Foundation

@main
struct SpokenlyToggle {
    static func main() {
        guard let url = URL(string: "spokenly://toggle") else {
            exit(EXIT_FAILURE)
        }

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = false

        let semaphore = DispatchSemaphore(value: 0)
        var succeeded = false

        NSWorkspace.shared.open(url, configuration: configuration) { _, error in
            succeeded = error == nil
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .now() + 2)
        exit(succeeded ? EXIT_SUCCESS : EXIT_FAILURE)
    }
}
