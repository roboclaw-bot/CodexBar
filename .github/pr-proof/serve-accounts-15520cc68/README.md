# Current-main account-serving HTTP evidence

Exact source: **15520cc68a5ff70d52dcf2bd6c1afa1261d51310**; integrated main **b59aee6ff2d26cd2c5632ce4f9d91e5fc4a1ef78**.

These JSON files are unmodified responses from the compiled production HTTP server. All accounts, addresses, aliases, credentials, usage, and adapter output are synthetic. No live provider, browser cookie, real account, or Keychain was used. No credential files, headers, or raw process logs are published. provenance.json binds the source tree, binary digest, assertions, and response file hashes.

- Codex healthy/private/full/redacted/selected/timeout: two profile homes, second selected, first usage 20%, second 65% with 42.5 credits. Private expansion uses Account 1/2 and null identities. A malformed synthetic inventory adds only the generic warning. A timed-out selected account does not erase the first account's usage. Ordinary selected mode omits the account array; raw /usage still enumerates both Codex profiles.
- Claude rows/failure/empty, each private/full/redacted: the real subprocess adapter and parser are exercised. A deliberately configured token account must not become a fallback. Whole-adapter failure omits accounts; successful-empty keeps accounts: []. Private modes suppress aliases and identifying raw errors while preserving healthy usage.
- Every snapshot scenario asserts unauthenticated 401, authorized 200, and Cache-Control: no-store.
- auth-routes.json records a separate non-loopback-bind test inside the network-isolated container: missing/wrong tokens yield 401 on all three data routes before invalid-provider validation; authorized invalid-provider requests yield 400. The public shell and health endpoint remain 200.

Cache-scope separation, retained-source generation safety, and avoiding redundant Claude credential fetches are covered by the source's focused Swift tests rather than inferred from these captures. The macOS suite also executes the production JavaScript renderer and upstream browser-display-preference tests.

Native verification: https://github.com/roboclaw-bot/CodexBar/actions/runs/36246764946 (see the live conclusion; this document does not assert success before it completes).

Discussion/implementation: https://team.openclaw.ai/chat/roboclaw/dashboard/51580e92-be0c-43e7-961e-4338d24c9ac2
