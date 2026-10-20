# Oura Ring API Info

Yes, you can use the Oura API to pull your ring data to your own system. You’ll need an Oura account and an API application, and you can create that in Oura’s newest developer portal; the full setup and endpoints are in Oura API V2 documentation. Gen3 and later also need an active Oura Membership for API access, and partner apps can’t access data for Gen3 and later without one.

## Links
- [My Applications](https://cloud.ouraring.com/oauth/applications)
- [Developer (needs signin)](https://developer.ouraring.com/signin?callbackUrl=%2Fapplications)
- [Oura API Documentation (2.0)](https://cloud.ouraring.com/v2/docs)

## Redirect URI options (personal single-user app)

The "New Application" form asks for a Redirect URI. Since this app is only
for personal use, a public server is not needed. Options, easiest first:

1. **Plain localhost** — `http://localhost:8080/callback` (or similar port).
   Works if Oura accepts localhost as a valid redirect.
2. **Wildcard local-pointing DNS** — `http://kan.lvh.me:8080/callback`.
   Services like `lvh.me`, `nip.io`, `sslip.io` are public DNS names that
   resolve straight back to `127.0.0.1` (your own machine). Useful if the
   form insists on a real-looking domain but you're still just running
   this locally.
3. **Dynamic DNS / tunnel** — only needed if the app truly must be reachable
   from outside your machine. Free options: DuckDNS, No-IP, or Cloudflare
   Tunnel (Cloudflare Tunnel skips router port-forwarding entirely).

   Keith's pick: **No-IP** (used before, familiar). Plan: subdomain like
   `oura.[no-ip hostname]`, redirect on port 80 or 443 if available
   (standard web ports — fewer firewall/router surprises than a custom port).