import Foundation

class ThemetySync {
    private let configPath: String
    private var fileMonitor: DispatchSourceFileSystemObject?
    private var lastTheme: String = ""
    private var suppressFileWatch = false

    init() {
        self.configPath = NSString(string: "~/.claude.json").expandingTildeInPath
    }

    func start() {
        syncTheme()

        // Listen for macOS appearance changes
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleThemeChange),
            name: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )

        // Watch ~/.claude.json for external writes that drop the theme key
        startFileWatch()

        print("themety-sync started. Watching appearance + ~/.claude.json")
        RunLoop.current.run()
    }

    @objc private func handleThemeChange() {
        print("macOS appearance changed")
        syncTheme()
    }

    private func startFileWatch() {
        let fd = open(configPath, O_EVTONLY)
        guard fd >= 0 else {
            print("Warning: could not open \(configPath) for watching")
            return
        }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: [.write, .rename, .delete],
            queue: .main
        )

        source.setEventHandler { [weak self] in
            guard let self = self, !self.suppressFileWatch else { return }
            // Small delay to let the writer finish
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.ensureThemeKey()
            }
        }

        source.setCancelHandler {
            close(fd)
        }

        source.resume()
        fileMonitor = source
    }

    private func ensureThemeKey() {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: configPath),
              let data = fileManager.contents(atPath: configPath),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }

        let currentTheme = json["theme"] as? String ?? ""
        if currentTheme != lastTheme {
            print("~/.claude.json missing or wrong theme (got '\(currentTheme)', expected '\(lastTheme)'), re-applying")
            syncTheme()
        }
    }

    private func syncTheme() {
        let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
        let theme = isDark ? "dark" : "light"
        lastTheme = theme

        if updateConfig(theme: theme) {
            print("Theme set to: \(theme)")
        } else {
            print("Failed to update ~/.claude.json")
        }
    }

    private func updateConfig(theme: String) -> Bool {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: configPath),
              let data = fileManager.contents(atPath: configPath),
              var json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("Error: could not read ~/.claude.json")
            return false
        }

        if let current = json["theme"] as? String, current == theme {
            return true
        }

        json["theme"] = theme

        guard let updatedData = try? JSONSerialization.data(
            withJSONObject: json,
            options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        ) else {
            return false
        }

        suppressFileWatch = true
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.suppressFileWatch = false
            }
        }

        do {
            try updatedData.write(to: URL(fileURLWithPath: configPath), options: .atomic)
            return true
        } catch {
            print("Error writing: \(error)")
            return false
        }
    }
}

let sync = ThemetySync()
sync.start()
