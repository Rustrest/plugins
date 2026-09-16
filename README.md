# Rustrest Plugins

This is the plugin index for [Rustrest](https://github.com/SojebSikder/rustrest). The **Browse** view in Rustrest's Manage Plugins tab fetches `index.json` from this repo's `main` branch, so submitting a plugin here is what makes it show up (and installable with one click) for every Rustrest user - it's not a change to Rustrest itself.

Rustrest itself only ever reads `index.json` directly from `main` - opening a PR here doesn't affect anything until it's merged.

## How it works

1. You build and host your own plugin (source, releases, etc.) wherever you like - your own repo is the natural place.
2. You attach a `.zip` containing your plugin's `plugin.toml` + `plugin.wasm` to a GitHub Release (or any stable URL).
3. You open a pull request here adding one entry to `index.json`.
4. Once merged, Rustrest's Browse tab lists it; clicking **Install** downloads the zip, verifies it (if you provided a checksum), and installs it exactly like a local folder install.

Rustrest doesn't build or host your plugin - this repo only indexes a `download_url` you control. See [Rustrest's plugin development guide](https://github.com/SojebSikder/rustrest/blob/main/docs/plugin-development.md) for how to build a plugin from scratch.

## `index.json` schema

```json
{
  "plugins": [
    {
      "id": "example",
      "name": "Example Plugin",
      "version": "0.1.0",
      "author": "Your Name",
      "description": "One or two sentences describing what it does.",
      "download_url": "https://github.com/<you>/<repo>/releases/download/v0.1.0/example.zip",
      "sha256": "optional - sha256 of the zip, recommended for integrity-checked installs",
      "homepage": "optional - link to your plugin's repo or docs"
    }
  ]
}
```

| Field          | Required | Notes                                                                                     |
| -------------- | -------- | ------------------------------------------------------------------------------------------ |
| `id`           | yes      | Must match the `id` in your plugin's own `plugin.toml`, and must be unique in this index.   |
| `name`         | yes      | Display name shown in the Browse list.                                                     |
| `version`      | yes      | Shown next to the name; bump this (and `download_url`) on every release.                   |
| `author`       | yes      | Shown next to the name.                                                                    |
| `description`  | yes      | One or two sentences.                                                                      |
| `download_url` | yes      | Direct link to a `.zip` with `plugin.toml` + `plugin.wasm` at its root (or one folder deep). |
| `sha256`       | no       | Lowercase hex sha256 of the zip. If present, Rustrest verifies it before installing.        |
| `homepage`     | no       | Link shown to users wanting more info before installing.                                   |

## Submitting a plugin

1. Fork this repo.
2. Add your entry to the `plugins` array in `index.json` (keep it alphabetically sorted by `id`).
3. Open a pull request. CI checks that `index.json` is valid and every entry has the required fields and a unique `id`.
4. Once merged, your plugin appears in Rustrest's Browse tab.

Updating an existing plugin (new version) is the same flow: bump `version` and `download_url` (and `sha256`, if used) in your existing entry.
