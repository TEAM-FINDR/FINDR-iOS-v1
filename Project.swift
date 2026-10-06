import ProjectDescription

let project = Project(
    name: "FINDR",
    targets: [
        .target(
            name: "FINDR",
            destinations: .iOS,
            product: .app,
            bundleId: "com.findr.ios",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": ""
                    ],
                    "UIAppFonts": [
                        "Fonts/NotoSansKR[wght].ttf"
                    ]
                ]
            ),
            buildableFolders: [
                "Sources",
                "Resources"
            ],
            dependencies: [],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": ""
                ]
            )
        ),
        .target(
            name: "FINDRTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.findr.ios.tests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            buildableFolders: [
                "Tests"
            ],
            dependencies: [
                .target(name: "FINDR")
            ]
        )
    ]
)
