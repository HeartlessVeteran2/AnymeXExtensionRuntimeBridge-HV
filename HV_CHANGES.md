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
