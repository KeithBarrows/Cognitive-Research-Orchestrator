# TheBrain API

TheBrain can now be controlled by a full-featured REST API. Designed for experienced programmers, the API opens up a world of possibilities. Access to a rich set of functions for querying, creating and modifying all types of data is included. Create thoughts automatically in response to events in the real world. Automate processes for moving thoughts through a workflow. Implement custom import/export logic. Control your brain from your watch or with your voice. These are just a few of the applications that are now open to pursue. Get started now at https://api.bra.in.

## Links
- [Introducing TheBrain API](https://www.thebrain.com/blog/introducing-thebrain-api) — open, no login
- [TheBrain API (Swagger)](https://api.bra.in/index.html) — page is open to view; using the API needs an API Key (generate one, then click Authorize on this page)
- [Generate an API Key](https://app.thebrain.com/login/?returnUrl=%2Fapi-keys) — needs login AND an active Cloud Services subscription ("You must have an active Cloud Services subscription to access this page.")

## Local API (no subscription needed)

The desktop app has its own Local API, separate from the cloud API above.
Found in the app: **Settings > User > Local API**.

- No Cloud Services subscription needed — free with the desktop app.
- Own API key, generated right there in Settings. Stored on this device only, not synced.
- Endpoint: `http://localhost:8001/api/`
- Docs: `http://localhost:8001/api/index.html` (only works while the desktop app is running)
- Key is tied to the logged-in user; works only on this device.
- Key works even when the user is signed out of the desktop app, so keep it secret.
- Changes made through the Local API apply directly to this device's data
  (vs. the cloud API, which changes the server and syncs down to local copies).
- Settings page has an "Open API Documentation" button and a "Regenerate Key" button.