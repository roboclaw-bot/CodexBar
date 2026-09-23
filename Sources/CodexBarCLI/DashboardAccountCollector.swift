import CodexBarCore
import Foundation

extension CodexBarCLI {
    static func serveIncludesConfiguredAccounts(
        provider: UsageProvider, config: CodexBarConfig, allAccounts: Bool) -> Bool
    {
        allAccounts && TokenAccountSupportCatalog.support(for: provider) != nil
            && config.providerConfig(for: provider.instanceID)?.tokenAccounts?.accounts.isEmpty == false
    }

    /// Publish a complete fallback shape before each fetch. Finished siblings keep
    /// their data; unfinished accounts have account-local timeout rows without usage-cache keys.
    static func collectAccountUsage(
        provider: UsageProvider,
        accounts: [DashboardUsageAccount?],
        inventoryIncomplete: Bool = false,
        minimumDelay: Duration? = nil,
        publishPartial: CLIServeOperationCoordinator<UsageCommandOutput>.PublishPartial? = nil,
        fetch: @Sendable (Int) async -> UsageCommandOutput) async -> UsageCommandOutput
    {
        var output = UsageCommandOutput()
        for index in accounts.indices {
            var fallback = output
            if publishPartial != nil {
                for account in accounts[index...] {
                    var timeout = Self.serveProviderTimeoutOutput(provider: provider)
                    timeout.attachDashboardAccount(account, inventoryIncomplete: inventoryIncomplete)
                    fallback.merge(timeout)
                }
            }
            if let publishPartial {
                await publishPartial(fallback)
                if Task.isCancelled { return fallback }
            }
            if index > 0, let minimumDelay {
                do {
                    try await Task.sleep(for: minimumDelay)
                } catch {
                    return publishPartial == nil ? output : fallback
                }
            }
            var result = await fetch(index)
            result.attachDashboardAccount(accounts[index], inventoryIncomplete: inventoryIncomplete)
            output.merge(result)
        }
        return output
    }
}
