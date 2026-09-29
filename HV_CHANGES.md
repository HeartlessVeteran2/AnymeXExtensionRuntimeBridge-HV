# What this fork changes

AnymeXExtensionRuntimeBridge-HV is a fork of
[AnymeXExtensionRuntimeBridge](https://github.com/RyanYuuki/AnymeXExtensionRuntimeBridge) by
RyanYuuki. It is the extension bridge that
[AnymeX-HV](https://github.com/HeartlessVeteran2/AnymeX-HV) uses. The fork keeps upstream's
code and adds a few fixes on top.

Each change below links to the pull request that made it.

## Mangayomi sources get all their settings

Mangayomi sources now receive these fields from the repository index:

- `apiUrl`
- `dateFormat` and `dateFormatLocale`
- `additionalParams` and `notes`
- `hasCloudflare` and `isFullData`

Before, these fields were dropped, so sources that rely on them didn't work properly. For
example, MangaDex needs its API URL, and Madara-based sites need a date format.

Sources installed before this change are filled in from their repository entry the next time
extensions are checked for updates. Only string values are accepted for the text fields; a
malformed repository value is ignored instead of being passed on as text.
[#1](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/1),
[#3](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/3)

## The repository list stays filled after a restart

After a restart, Extensions → Repositories showed no Mangayomi repositories, although their
extensions kept working (AnymeX #585). The Mangayomi manager read its saved repositories to
fetch extensions, but only filled the list the screen shows when a repository was added or
removed. It now fills it when it loads, as the Aniyomi and Sora managers do. A repository saved
without its manager gets it, so it can still be removed from the screen.
[#5](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/5)

## APK extensions install one at a time

Installing two Mihon/Aniyomi extensions at once ("Update all", or two quick taps) crashed the
app. APK installs go through install_plugin, which keeps a single pending result: the second
install replaced it, and the second reply to the same call threw "Reply already submitted" on
Android's main thread. Installs, updates and removals of these extensions now run one at a time.
[#5](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/5)

## Page loading says why it failed

When a Mangayomi source (or an Aniyomi one on desktop) failed to load a chapter's pages, the
bridge logged the error and returned an empty list, so the app could only show "No pages
found". It now passes the error on, as the Android Aniyomi, Kotatsu and Sora sources already
did, so the app shows the reason: no connection, Cloudflare, a site that changed, and so on.
[#5](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/5)

## Runtime downloads come from this fork

These now download from this repository's releases instead of upstream's:

- the Android runtime host (`anymex_runtime_host.apk`);
- the desktop runtime (`.jar`);
- the torrent engine.

A daily workflow (`.github/workflows/mirror-runtime-releases.yml`) copies upstream's recent
releases here, with the same tags, notes and files. Upstream's runtime builds still reach users
of this fork, but the app depends only on this repository. The README and the Windows setup
script point here too.

The mirror has these safeguards:

- If it can't read which upstream release is the latest, the run fails, so the wrong release
  is never marked latest.
- A release whose download fails is skipped and retried the next day. It is never published
  with only some of its files.

The app downloads the release marked **Latest** here (GitHub's `releases/latest`), not the one
with the highest version number. The mirror marks a copied release Latest when it is upstream's
latest. To ship your own build instead, publish it here as Latest. The next time the mirror
copies a newer upstream release, that release becomes Latest again.
[#2](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/2),
[#3](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/3)

## Smaller fixes

- **README:** the Windows setup example now actually passes flags such as `--force-jar` to
  the script. `irm ... | iex -- --force-jar` never forwarded them.
- **`.gitignore`:** `build/` is ignored. Running the tests writes generated files there.

[#3](https://github.com/HeartlessVeteran2/AnymeXExtensionRuntimeBridge-HV/pull/3)

## Tests

This repository ignores its own `test/` folder, so the tests for these changes live in
AnymeX-HV:
[`test/hv/extensions/`](https://github.com/HeartlessVeteran2/AnymeX-HV/tree/main/test/hv/extensions).
AnymeX-HV pins this fork by commit in its `pubspec.yaml`.
