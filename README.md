# VinipoonPN
Orbital
## Milestone 1
*Before this orbital, both of us are completely new to networks and cybersecurity, so we spent a week to catch up on the basic knowledges, and in the second week we tried several tools and most of them doesn't work. Finally we set up the plan and use openvpn to build tunnel. Because of this, we did not have enough time to spend on software engineering part, and software engineering is not the most essential component in our project. Therefore, we are unable to provide a working demo for everyone to use. You may refer to our proof of concept video for our demo*

### Core features
1. access the web anonymously
2. bypass some firewall
3. change ip address
4. GUI (because many vpn doesn't have it)
5. (extension) send anonymous message to other users
6. (extension) anonymous email services

### Plan
The two essential components of a VPN are the encrypted tunnel and the server. For the tunnel, we use the OpenVPN protocol to implement the client-server tunnel, given time constraints, instead of developing it from scratch. For the server, we will deploy cloud-based servers located in different regions to implement features 2 and 3. In the proof-of-concept video, we successfully established a simple client-server tunnel between two computers. The GUI is designed to replace the command-line interface typically used by most self-built VPNs. For features 5 and 6, we will perform basic software engineering to add a user login system, enable user communication, and allow users to send and receive emails using an anonymous address. We considered to use flutter as frontend and django as backend.
