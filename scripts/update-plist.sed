#!/usr/bin/env -S sed -f

/<key>CFBundleName<\/key>/ {
  n
  c \\t<string>Zero Percent Juice</string>
}

/<key>CFBundleIdentifier<\/key>/ {
  n
  c \\t<string>edu.sunypoly.cs371.zpj</string>
}

/^\t<key>UTExportedTypeDeclarations<\/key>/,/^\t<\/array>/ {
  d
}
