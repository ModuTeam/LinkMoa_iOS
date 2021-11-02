import ProjectDescription
import ProjectDescriptionHelpers

let settings = Settings(base: LinkMoaBaseSetting.settings())

let targets = LinkMoa.allCases.map {
    Target(
        name: $0.name,
        platform: $0.platform,
        product: $0.product,
        bundleId: $0.bundleId,
        deploymentTarget: $0.deploymentTarget,
        infoPlist: $0.infoPlist,
        sources: $0.sources,
        resources: $0.resources,
        entitlements: $0.entitlements,
        dependencies: $0.dependencies
    )
}

let project = Project(
    name: LinkMoa.appName,
    organizationName: LinkMoa.bundleID,
    settings: settings,
    targets: targets
)
