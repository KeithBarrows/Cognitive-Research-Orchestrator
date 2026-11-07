# Feature 08 — Local DNS Resolver

*(Part of Epic 0 — Installs. See `../../phase-0-plan.md` for the full
Epic.)*

**Changed 2026-11-06:** there is no resolver. The name works through a
fixed laptop address and a hosts-file line on each desktop. See
`DECISIONS.md`, 2026-11-06. The folder and file names stay as they are.
The earlier dnsmasq design is in git history before this change.

## Install

- **Laptop:** a static address on the home Wi-Fi network ("Dolphin"):
  `192.168.9.250`, prefix `24` (255.255.255.0), gateway `192.168.9.1`,
  DNS `192.168.9.1`. Set per Wi-Fi network in Windows 11, so other
  networks still use DHCP when traveling. It is outside the router's
  DHCP range (192.168.9.100-249), so nothing else can be given it.
  `192.168.9.251` is kept for Ethernet if it is ever used.
- **Each desktop:** one line in
  `C:\Windows\System32\drivers\etc\hosts` (edit as administrator):
  `192.168.9.250  cro.home.sol3.net`
- **Router:** unchanged. The Gryphon router and mesh can be changed
  only through its mobile app; nothing here needs it.

**Why not dnsmasq:** Windows Internet Connection Sharing already holds
port 53 on the laptop. A router DNS change reaches every device in the
house, and when the laptop is off or away devices either lose DNS or
skip the local name. For one or two desktops a hosts file is simpler
and cannot break the rest of the house.

## Test

Done 2026-11-06:
- Laptop: `Get-NetIPAddress` shows `192.168.9.250/24`, origin Manual;
  the router, `1.1.1.1` and a lookup of `example.com` all work.
- Desktop: `ping 192.168.9.250` and `ping cro.home.sol3.net` both
  answer.

## Known limits

- Phones and tablets cannot easily edit a hosts file. They use the
  address directly, or a public record can be added later.
- Every new computer needs the same one-line hosts edit.
- Ethernet is not configured. On Ethernet the address would differ and
  the hosts line would point at the wrong IP.
- The name resolves, but nothing on the laptop answers on the LAN yet:
  OB1, Plane and `cro_index` listen on `127.0.0.1` only (decided
  2026-11-06). Opening a LAN port is a separate decision under the
  2026-10-17 home-network-only boundary.

## Not yet designed

See Feature 09 — the travel-access naming scheme is a separate Feature.
