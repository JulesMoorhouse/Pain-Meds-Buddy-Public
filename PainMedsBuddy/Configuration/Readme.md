# Secrets
The `Secrets.swift` file is encyprted using `git-crypt`.

Here's an example of the contents of the file..

```
import Foundation

struct Secrets {
    static let appCenterSecret: String = "Your api key here"
}

```