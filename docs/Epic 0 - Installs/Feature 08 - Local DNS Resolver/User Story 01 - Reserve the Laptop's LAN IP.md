# User Story 01 — Reserve the Laptop's LAN IP

**Status:** Done

**Story:** As the CRO developer, I want the laptop to keep one LAN IP, so the DNS name always points at the right place.

**Done when:** The Gryphon router reserves a fixed IP for the laptop, and the IP is written here for both Wi-Fi and Ethernet.

**Notes:** Wi-Fi and Ethernet have different MAC addresses and so may get different IPs; decide which one the DNS record uses. Gap found while reading Feature 08 on 2026-11-05.
Done 2026-11-06 a different way: a static address on the laptop,
`192.168.9.250`, outside the DHCP range (100-249), set per Wi-Fi
network. No router reservation.
