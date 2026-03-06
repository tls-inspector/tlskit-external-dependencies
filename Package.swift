// swift-tools-version: 6.2

// TLSKit
// Copyright (C) Ian Spence and other TLSKit Contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import PackageDescription

let package = Package(
    name: "tlskit-external-dependencies",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Curl",
            targets: ["Curl"]
        ),
        .library(
            name: "OpenSSL",
            targets: ["OpenSSL"]
        ),
    ],
    targets: [
        .binaryTarget(name: "Curl", path: "curl.xcframework"),
        .binaryTarget(name: "OpenSSL", path: "openssl.xcframework"),
    ]
)
