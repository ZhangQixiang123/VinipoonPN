# VinipoonPN
Orbital
## Milestone 1
*Before this orbital, both of us are completely new to networks and cybersecurity, so we spent a week to catch up on the basic knowledges, and in the second week we tried several tools and most of them doesn't work. Finally we set up the plan and use openvpn to build tunnel. Because of this, we did not have enough time to spend on software engineering part, and software engineering is not the most essential component in our project. Therefore, we are unable to provide a working demo for everyone to use. You may refer to our proof of concept video for our demo*

### Core features
1. access the web anonymously
2. bypass some firewall
3. change ip address
4. GUI (because many vpn doesn't have it)
5. browser based, can run on any device with a browser
6. (extension) send anonymous message to other users
7. (extension) anonymous email services
   

### Plan
The two essential components of a VPN are the encrypted tunnel and the server. For the tunnel, we use the OpenVPN protocol to implement the client-server tunnel, given time constraints, instead of developing it from scratch. For the server, we will deploy cloud-based servers located in different regions to implement features 2 and 3. In the proof-of-concept video, we successfully established a simple client-server tunnel between two computers. The GUI is designed to replace the command-line interface typically used by most self-built VPNs. For features 5 and 6, we will perform basic software engineering to add a user login system, enable user communication, and allow users to send and receive emails using an anonymous address. We considered to use flutter as frontend and django as backend.

### Implementation Philosophy
*Our implementation philosophy focuses on creating a secure, user-friendly, and accessible VPN solution that prioritizes user privacy and anonymity. By leveraging existing robust technologies and protocols, we aim to deliver a reliable and efficient VPN service that meets the needs of users seeking to protect their online presence and bypass regional restrictions.*

1.**Security First**: Our primary goal is to ensure the security and privacy of our users. We will use the OpenVPN protocol to establish secure encrypted tunnels, ensuring data integrity and confidentiality. Regular security audits and updates will be a part of our ongoing maintenance to safeguard against vulnerabilities.

2.**User-Centric Design**: The VPN will be designed with the end-user in mind, featuring a simple and intuitive GUI that makes it easy for anyone to use, regardless of technical expertise. This includes seamless navigation, clear instructions, and accessible support options.

3.**Accessibility and Compatibility**: Our solution will be browser-based to ensure it can run on any device with a browser, eliminating the need for specific hardware or operating systems. This approach maximizes accessibility and convenience for users.

4.**Transparency and Trust**: We commit to transparency in our operations, including clear privacy policies and open communication about how user data is handled. Users will have control over their data and the ability to manage their settings within the application.

5.**Community and Collaboration**: Building a community around our VPN service is essential. We will facilitate user communication through secure, anonymous messaging and email services. Feedback from users will be actively sought and incorporated into future development cycles.

### Software Engineering Principles
1.**Modular Design**: The system will be designed in a modular fashion, allowing individual components (such as the VPN client, server management, user authentication, and messaging systems) to be developed, tested, and maintained independently. This promotes scalability and ease of maintenance.

2.**Agile Development**: We will adopt Agile methodologies to ensure a flexible and iterative development process. This allows us to quickly respond to user feedback, adapt to changing requirements, and deliver incremental improvements regularly.

3.**Code Quality and Maintainability**: Adherence to best practices in coding standards, including thorough documentation, code reviews, and automated testing, will ensure the quality and maintainability of the codebase. Continuous integration and deployment (CI/CD) pipelines will be set up to streamline development and deployment processes.

4.**Security by Design**: Security considerations will be integrated into every stage of the development process. This includes secure coding practices, regular vulnerability assessments, and the implementation of robust authentication and authorization mechanisms.

5.**Performance and Scalability**: The system architecture will be designed to handle varying loads efficiently, with a focus on performance optimization and scalability. Cloud-based servers will be used to dynamically allocate resources based on demand, ensuring consistent performance for users globally.

6.**User Privacy and Data Protection**: Strong encryption methods will be employed to protect user data in transit and at rest. We will also minimize data collection and implement strict data retention policies to further enhance user privacy.

7.**Cross-Platform Compatibility**: By using technologies like Flutter for the frontend and Django for the backend, we ensure cross-platform compatibility, allowing our application to run seamlessly on different devices and operating systems.

### Implementation Steps
1. **Setup and Configuration**:
- Configure cloud-based servers in different regions.
- Implement OpenVPN for secure tunneling.

2. **Frontend Development**:
- Develop a user-friendly GUI using Flutter.
- Ensure the interface is intuitive and accessible.

3. **Backend Development**:
- Set up Django for handling user authentication, session management, and server communication.
- Develop APIs for VPN connection management, messaging, and email services.

4. **Integration**:
- Integrate the frontend with the backend.
- Implement secure communication protocols between components.

5. **Testing**:
- Conduct thorough testing, including unit, integration, and system tests.
- Perform security audits and penetration testing.

6. **Deployment**:
- Deploy the application to production servers.
- Set up monitoring and logging for ongoing maintenance.

