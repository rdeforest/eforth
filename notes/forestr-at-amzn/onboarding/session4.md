# Packet capture agent

- Packets only captured in Edge worker hosts
- LookoutPacketCaptureAgent Apollo env on edge (CF/R53) workers
 - L1s on CF
 - Equiv. on R53 stack
 - BW emits packet capture data that Lookout pulls
- Separate threads devoted to capture and transfer of pcap
- Transfer accomplished via TCP connection (coral?) to mid-aggregators
- Uses a round-robin mechanism to ensure delivery

# Signiture Generation Tool

- Kinda like a diff of baseline vs an anomalous time
