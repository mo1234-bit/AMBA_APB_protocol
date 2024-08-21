# APB-Protocol

## Overview

The Advanced Peripheral Bus (APB) is optimized for peripherals with low bandwidth requirements. This protocol is commonly used to connect devices like UARTs, keypads, timers, and Peripheral Input/Output (PIO) devices. The APB operates under a bridge, which links it to the higher performance AHB or ASB buses. In this setup, the bridge acts as the master, while the connected peripherals are the slaves.

## Features

- **Parallel Operation:** All data is captured on the rising edge of the clock.
- **Dual Slave Configuration:** Supports two slave devices.
- **Signal Priority:**
  - **PRESET** (active low)
  - **PSEL** (active high)
  - **PENABLE** (active high)
  - **PREADY** (active high)
  - **PWRITE**
- **Data & Address Widths:** 8-bit data width and 9-bit address width.
- **Write/Read Operations:**
  - `PWRITE=1`: Write `PWDATA` to the slave.
  - `PWRITE=0`: Read `PRDATA` from the slave.
- **Transmission Indicators:**
  - Start: `PENABLE` changes from low to high.
  - End: `PREADY` changes from high to low.

## File Structure

- **Top Module:** `apb_protocol.v`
- **Testbench:** `test.v`

## Diagrams

### APB Interface Diagram

![APB Interface Diagram](https://user-images.githubusercontent.com/82434808/122651062-0bc74980-d154-11eb-9737-591e928a734e.png)

### APB Operation Diagram

![APB Operation Diagram](https://user-images.githubusercontent.com/82434808/122651071-1681de80-d154-11eb-9977-9d46bacd77b9.png)

### Write operations on the 2 slaves
<img width="953" alt="read op" src="https://github.com/user-attachments/assets/b8b31137-e3f4-4924-a3ab-12609bbab8e5">

### READ operations from the 2 slaves
<img width="946" alt="write op" src="https://github.com/user-attachments/assets/9ceb348c-69c6-4ecc-88ac-60fc5101917c">

### The Full schematic after synthesis
<img width="462" alt="sch" src="https://github.com/user-attachments/assets/7dbab700-6bbb-45c5-baf8-60b9242e9bfd">

### The MASTER schematic after synthesis
<img width="241" alt="master" src="https://github.com/user-attachments/assets/cef0325d-8bf1-46c9-bfde-c12b6748085d">

### the slave1 and slave2 schematic after synthesis
slave1

<img width="434" alt="slave1(ram)" src="https://github.com/user-attachments/assets/cc6c8da2-a25c-42be-a93a-d490bebab96d">

slave2

<img width="408" alt="slave2" src="https://github.com/user-attachments/assets/d1b969b4-7c1a-4982-8cdc-7e811c97425a">


## Pin Description

Detailed descriptions of each pin used in the APB protocol.

---

## Setting Up the Repository

To set up this repository locally and include the README file, follow these steps:

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/apb-protocol.git
cd apb-protocol
