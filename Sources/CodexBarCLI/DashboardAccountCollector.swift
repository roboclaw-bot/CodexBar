import CodexBarCore
import Foundation

extension CodexBarCLI {
    /// Publish a complete fallback shape before each fetch. Finished siblings keep
    /// their data; unfinished accounts have account-local timeout rows without usage-cache keys.
    static func collectAccountUsage(
        provider: UsageProvider,
        accounts: [DashboardUsageAccount?],
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
                    if let account { timeout.attachDashboardAccount(account) }
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
            if let account = accounts[index] { result.attachDashboardAccount(account) }
            output.merge(result)
        }
        return output
    }
}
