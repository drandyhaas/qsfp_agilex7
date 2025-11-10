# qsfp_agilex7

A simple example of QSFP communication on an Agilex7 dev board

Build with Quartus Pro, last tested with 24.2.0

As is, the IP is set for 25.6506 Gbps on QSFP 0, 1, and 2. This requires changing the clocks to 160.31625 MHz for:
 - Si5395_2 OUT5 : QSFP 0
 - Si5395_2 OUT3 : QSFP 1
 - Si5395_1 OUT5 : QSFP 2

[Presentation with some examples](https://docs.google.com/presentation/d/1cGxoR07bYmIaMoPiCWv5rQUwGxbPK5B1rellOR2aTSY/edit?usp=sharing)

Other speeds and settings would be configured via the IP's shown here:

![Screenshot 2025-10-28 154158.png](pics%2FScreenshot%202025-10-28%20154158.png)

Firmware is configured at runtine via the Quartus XCVR Toolkit:

![Screenshot 2025-10-28 141601.png](pics%2FScreenshot%202025-10-28%20141601.png)

