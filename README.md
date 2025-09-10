# Simple APRS iGate with RTL-SDR

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![APRS](https://img.shields.io/badge/APRS-Compatible-green.svg)](http://www.aprs.org/)

A minimal, cost-effective APRS iGate setup using RTL-SDR for receive-only operation. Perfect for amateur radio operators wanting to contribute to the APRS network with minimal investment.

## 🚀 Features

- **Ultra Low Cost**: ~€50 total hardware cost
- **Receive-Only**: No RF transmission, just monitoring and forwarding
- **Docker Based**: Easy deployment and maintenance
- **Minimal Hardware**: Raspberry Pi Zero + RTL-SDR dongle
- **Professional APRS Integration**: Connects to APRS-IS servers
- **Remote Monitoring**: TCP interface for live packet viewing

## 📋 Hardware Requirements

| Component | Cost (approx) | Description |
|-----------|---------------|-------------|
| Raspberry Pi Zero W | €20-25 | ARM processor with WiFi |
| RTL-SDR Dongle | €15-20 | RTL2832U chipset |
| VHF Antenna | €5-10 | 144-148MHz optimized |

## 🔧 Quick Start

### Prerequisites

- Valid Amateur Radio License with callsign
- Linux system with Docker and Docker Compose installed
- APRS-IS passcode (get from [apps.magicbug.co.uk](https://apps.magicbug.co.uk/passcode/))

### 1. Clone Repository

```bash
git clone https://github.com/N1k0droid/simple-aprs-igate.git
cd simple-aprs-igate
```

### 2. Configure Your Station

```bash
# Copy sample configuration
cp .env.sample .env

# Edit with your details
nano .env
```

**Required Settings:**
```bash
APRS_CALLSIGN=W1ABC-10      # Your callsign + SSID
APRS_PASSCODE=12345         # Your APRS-IS passcode
LATITUDE=40.7128            # Your GPS coordinates
LONGITUDE=-74.0060
```

### 3. Deploy iGate

```bash
# Build Docker image
docker compose build

# Start iGate service
docker compose up -d

# Monitor startup
docker logs -f aprs-igate
```

### 4. Verify Operation

```bash
# View live APRS packets
./scripts/igate_manager.sh packets

# Check iGate status
./scripts/igate_manager.sh status

# View on APRS.fi - search for YOUR_CALL-10
```

## 📊 Expected Results

Once operational, you should see:

**Console Output:**
```
[0] W1ABC>APRS,WIDE1-1:!4208.75N/07115.12W>Mobile Station
[0] << [IG] W1ABC>APRS,WIDE1-1:!4208.75N/07115.12W>Mobile Station
```

**APRS.fi Integration:**
- Your iGate appearing on the map with coverage radius
- Local RF traffic forwarded to Internet
- Received stations showing "via YOUR-CALL-10"

## 🛠 Management Commands

```bash
# Start iGate
./scripts/igate_manager.sh start

# Stop iGate
./scripts/igate_manager.sh stop

# Restart (after config changes)
./scripts/igate_manager.sh restart

# View logs
./scripts/igate_manager.sh logs

# Monitor packets
./scripts/igate_manager.sh packets

# Check status
./scripts/igate_manager.sh status
```

## ⚙️ Configuration Options

Edit `.env` file to customize your iGate:

| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `APRS_CALLSIGN` | Your callsign + SSID | `W1ABC-10` | ✅ |
| `APRS_PASSCODE` | APRS-IS passcode | `12345` | ✅ |
| `LATITUDE` | GPS latitude (decimal) | `40.7128` | ✅ |
| `LONGITUDE` | GPS longitude (decimal) | `-74.0060` | ✅ |
| `APRS_SERVER` | APRS-IS server | `euro.aprs2.net` | No |
| `FILTER_RADIUS` | Geographic filter (km) | `100` | No |
| `RTL_PPM` | Frequency correction | `0` | No |

### Regional Server Settings

| Region | Server | Port |
|--------|--------|------|
| Europe | `euro.aprs2.net` | `14580` |
| North America | `noam.aprs2.net` | `14580` |
| Asia-Pacific | `asia.aprs2.net` | `14580` |
| Global | `rotate.aprs2.net` | `14580` |

## 📡 Technical Details

### Frequency Configuration
- **Europe**: 144.800MHz
- **North America**: 144.390MHz
- **Modulation**: AFSK 1200 baud
- **Sample Rate**: 22.05 kHz

### APRS-IS Integration
- **Protocol**: APRS-IS TCP
- **Geographic Filtering**: Configurable radius
- **Beacon Interval**: 30 minutes
- **Packet Forwarding**: RF → Internet only

### Power Consumption
- **Raspberry Pi Zero W**: ~0.7W
- **RTL-SDR**: ~0.3W
- **Total**: ~1W (suitable for solar power)

## 🏗 Architecture

```
APRS RF (144.800MHz) → RTL-SDR → rtl_fm → Direwolf → APRS-IS → aprs.fi
```

### Software Components
- **rtl_fm**: RTL-SDR demodulation
- **Direwolf**: APRS packet decode/encode
- **Docker**: Containerized deployment
- **Ubuntu 22.04**: Base system

## 🔍 Troubleshooting

### No Packets Received

```bash
# Test RTL-SDR access
docker exec -it aprs-igate rtl_test -t

# Expected output: RTL-SDR device detected
```

**Common Issues:**
- Antenna not connected or poorly positioned
- No local APRS activity (verify with handheld radio)
- RTL-SDR device not accessible to container

### Connection Issues

```bash
# Verify callsign and passcode
cat .env | grep APRS_

# Test internet connectivity
ping euro.aprs2.net
```

**Common Issues:**
- Invalid APRS passcode
- Firewall blocking port 14580
- Network connectivity problems

### Container Problems

```bash
# View detailed logs
docker logs aprs-igate

# Rebuild container
docker compose build --no-cache

# Check Docker system
docker system info
```

### RTL-SDR Calibration

```bash
# Check frequency accuracy
rtl_test -p

# Run for 5-10 minutes and note PPM error
# Add the PPM value to your .env file
```

## 🌐 APRS Network Integration

Your iGate contributes to the global APRS network by:

1. **Receiving** local APRS packets on VHF frequency
2. **Decoding** packets using professional Direwolf TNC software
3. **Forwarding** to APRS-IS servers for global distribution
4. **Publishing** position beacon showing iGate location and coverage

### Coverage Display

Your iGate will appear on aprs.fi with:
- Gateway symbol (diamond with "R" overlay)
- Position beacon every 30 minutes
- Coverage radius based on received stations
- Statistics showing packets forwarded

### Development

```bash
# Build development image
docker compose build

# Run with logs
docker compose up

# Test configuration changes
./scripts/igate_manager.sh restart
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[Direwolf](https://github.com/wb2osz/direwolf)** - Professional APRS TNC software by WB2OSZ
- **[RTL-SDR](https://www.rtl-sdr.com/)** - Affordable SDR hardware enabling this project
- **[APRS-IS](http://www.aprs-is.net/)** - Internet backbone of the APRS network
- **Amateur Radio Community** - For developing and maintaining APRS

---

**73 & Happy DXing!** 📻
