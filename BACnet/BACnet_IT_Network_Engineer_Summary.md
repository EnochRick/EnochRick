# BACnet Introduction — Summary for IT Network Engineers

Please note: this is a document in progress.  There are sections I am consolidating.  

## What is BACnet?
BACnet (Building Automation Control Network) is an ANSI/ISO standard data communication protocol for building automation systems — HVAC, fire, lighting, security, elevators, etc. As an IT network engineer, you'll encounter it when building automation systems share your IP infrastructure.

---
### 1. Core Network Architecture & Layers
BACnet is a collapsed-stack protocol that maps to the OSI model, primarily operating at the Physical, Data Link, Network, and Application layers.

* **BACnet/IP: (Most Important for IT)** The primary implementation for modern IT infrastructures. It encapsulates BACnet messages within **UDP/IP** packets. It runs over UDP/IP and can share existing Ethernet, VLAN, and WAN infrastructure. Devices plug into standard Ethernet switches. 

    **Key caveat 1:** it uses **UDP broadcasts**, which cannot cross IP subnet boundaries. When BACnet/IP spans multiple subnets, **BACnet Broadcast Management Devices (BBMDs)** must be deployed on each subnet to forward those broadcasts. This is the most important thing for an IT engineer to understand — you may need to plan for or configure BBMDs, or ensure firewall/ACL rules allow UDP BACnet traffic (default port **47808/UDP**).
    
    **Key caveat 2:** BACnet contains its own layer of addressing that is independent of IP addressing, and what IT folks consider "MAC" addressing.  Even each network segment, including the IP segment(s) have their own addresses: This allows BACnet to setup its own routing as well and can be entirely encapsulated via UDP.  So even if the IT / IP side of the network is up and running correctly, doesnt mean the BACnet network is up and running correctly - it can still have BACnet addressing issues such as duplicate device addresses, improper network numbering, or lack of BBMD (explained later). 

* **Ethernet (ISO 8802-3):** BACnet can run natively on Ethernet (using frames directly). However, because it lacks an IP header, these frames are **non-routable** by standard IP routers and are restricted to a single physical broadcast domain.
* **MS/TP (Master-Slave/Token Passing):** A legacy 2-wire twisted-pair system based on **EIA-485**. These segments usually require a BACnet router to interface with the IP network. These "subnetworks" excel having wire lengths up to 4,000 feet creating a separate, isolated serial network that typically doesn't touch your IP infrastructure unless bridged through a gateway or router. Some larger IP BAS controllers (called global controllers) can act as this router. 

* **Other Supported Media:** Includes ARCNET, Point-to-Point (RS-232), and ZigBee (wireless mesh). The wireless mesh is typically used as a gateway to low-cost sensors distributed around the building for various needs of a facility. Not a native BACnet transport so its less common in buildings but important to still be aware of.


---
### 2. Addressing and Device Discovery
* **Device Instance Number:** Every BACnet device must have a **globally unique 32-bit instance number** across the entire internetwork (0 to 4,194,303). This is the primary identifier used by workstations to find controllers.
* **Dynamic Binding:** To resolve addresses, BACnet uses a "Who-Is" (broadcast) and "I-Am" (unmanaged response) mechanism to map the Device Instance to a specific IP or MAC address.
* **BACnet Routers:** These are application-specific devices that route traffic between different BACnet network types (e.g., bridging an MS/TP trunk to a BACnet/IP backbone).
## BACnet Routers

BACnet routers link dissimilar network types (e.g., BACnet/IP ↔ MS/TP). They pass BACnet messages between segments without altering message content. They are often built into automation controllers rather than being standalone devices — something to be aware of when troubleshooting or segmenting traffic.

---

## Network Traffic Considerations

**Device Discovery (Who-Is / I-Am)** — BACnet uses broadcast-based discovery. Devices broadcast "Who-Is" requests and others respond with "I-Am." This means BACnet broadcast traffic will be present on any subnet with BACnet/IP devices. Excessive broadcast traffic can be a concern on large flat networks.

**Change of Value (COV)** — A subscription-based mechanism where devices only send updates when a value changes beyond a threshold, reducing polling traffic. Clients must periodically re-subscribe to keep connections alive, which generates some background traffic.

**Trending** — Distributed data sampling, where edge devices store trend logs locally and upload in bulk to a supervisory system. This produces periodic bursts of data transfer rather than constant streams.

---

## Network Security

The document notes that BACnet includes a network security layer for applications involving access control, sensitive physical venues, or systems exposed to the public internet. This is worth flagging — BACnet systems connected to corporate IP networks without proper segmentation (VLANs, firewall rules) can be a security risk. Best practice is to isolate BACnet/IP traffic on a dedicated VLAN.

---

## Device & Network Management

BACnet supports dynamic device binding using Who-Is/I-Am broadcasts. Each device must have a **unique Device Instance number** across the entire BACnet internetwork. Duplicate instance numbers cause communication failures — relevant if you're expanding or merging BACnet networks.

---

## Enterprise Integration

BACnet has defined **Web Services (BACnet/WS)** using HTTP over TCP/IP and XML schemas, allowing enterprise applications to query building automation data. This is where BACnet crosses more directly into traditional IT territory and may require firewall rules or API gateway consideration.

---

## Key Takeaways for an IT Network Engineer

- Plan for **UDP broadcast traffic** on any subnet with BACnet/IP devices
- Deploy or verify **BBMDs** if BACnet spans multiple IP subnets
- Consider **VLAN segmentation** to isolate BACnet traffic from corporate traffic
- Be aware that **BACnet routers** are often embedded in building controllers, not separate appliances
- UDP port **47808** is the standard BACnet/IP port — ensure it's permitted where needed
- The **MS/TP** serial segments are separate from your IP network but connect via gateways/routers


### 3. IP Infrastructure Requirements
Integrating BACnet/IP into a managed network introduces specific requirements for firewalls and routing:

* **UDP Port:** BACnet/IP typically uses **UDP port 47808 (0xBAC0)**. This port must be open for both unicast and broadcast traffic.
* **BBMDs (BACnet Broadcast Management Devices):** Since standard IP routers block the broadcasts required for BACnet discovery, a BBMD is required in each IP subnet. The BBMD encapsulates BACnet broadcasts into unicast UDP packets to "tunnel" them to BBMDs in other subnets.
* **FD (Foreign Device) Registration:** Devices located on a subnet without a BBMD can register as a "Foreign Device" with a BBMD on a different subnet to receive broadcast traffic.

### 4. Operational Traffic Behavior
* **Client/Server Model:** BACnet operates on a request/response basis. A "Client" (e.g., a Niagara Station or Building Management Workstation) requests data, and a "Server" (e.g., a field controller) provides it.
* **Change of Value (COV):** To reduce network overhead, BACnet supports COV subscriptions. Instead of the client polling the server every few seconds, the server only pushes data when a value changes beyond a specified threshold.
* **Segmentation:** For large data transfers (like complex schedules or object lists) that exceed the MTU, BACnet manages its own segmentation and reassembly.

### 5. Security & Management
* **Network Security Layer:** The protocol includes specifications for a security layer that provides peer entity authentication, data origin authentication, and encryption.
* **Object-Oriented Data:** All data in a device is represented as **Objects** (e.g., Analog Input, Binary Output) with defined **Properties** (e.g., Present_Value, Status_Flags), making it highly structured for integration.

# Useful links:

I love these guys and their products: 

[https://www.ccontrols.com/video/bacnet.htm](https://www.ccontrols.com/video/bacnet.htm)

[https://www.ccontrols.com/lc/bacnet.htm](https://www.ccontrols.com/lc/bacnet.htm)

[https://store.chipkin.com/articles/bacnet-index-page](https://store.chipkin.com/articles/bacnet-index-page)
