# AES256-GCM-10G25G free evaluation demo

This repository contains source code and a brief description of the AES256-GCM-10G25G demo from Design Gateway's product.

## Basic information

1. The IP and project are not provided in this repository. Please contact [Design Gateway](https://dgway.com/contact.html) to obtain this free evaluation project.
2. The source code of this project is publicly available to demonstrate how to use this IP.
3. Design Gateway Co., Ltd. makes no claims, promises, or guarantees regarding the use of this free project. 
4. This evauluation demo includes a timeout limit.

## Project description
The AES256-GCM IP Core supports 256-bit AES encryption and decryption in Galois/Counter Mode (GCM) which is widely used for Authenticated Encryption with Associated Data (AEAD) application. More details about this IP can be found through this [link](https://dgway.com/ASIP_E.html#AESGCM).

This free demo showcases a basic system that highlights the functionality of our encryption IP core. The diagram below provides the overview of this free demo, with more details described further below.

![block-diagram](./docs/AES256GCM10G25GDemo.PNG)

Two AES256-GCM-10G25G IP cores are used in this system — one serving as an encrypter and the other as a decrypter. The encrypter is fed input data by the pattern generator, and the output of the encrypter is then forwarded to the decrypter. Ideally, the input data before encryption and the output data after decryption should be the same. Similarly, the authentication tag must maintain the same value during both encryption and decryption. This concept is verified using a comparator to check the two data feeds — the input data and the output data from the decrypter. If the two data sets do not match, the LED(0) is asserted to be '1'.  If the authentication tag from encryption and decryption does not match, LED(1) is asserted to '1'. On the other hand, LED(2) is asserted to indicate the current busy status of the two IP cores in this system.

The project directory is briefly explained below.
```
├───docs - documents and their associated objects 
└───source 
    ├───ip - directory for the encrypted IP file
    └───hdl-top - HDL files of this project
```

In addition to this free evaluation demo, we provide other demo applications for this IP core, please visit our [website](https://dgway.com/ASIP_E.html#AESGCM)
 for more information. 

Moreover, our IP is applicable for communication security protocols such as TLS. We also offer a complete TLS system, [TLS10G-IP](https://dgway.com/ASIP_E.html#TLS), which includes AES256GCM-IP to archive transfer speed up to 10 Gbps. For further details on our TLS-IP and its demonstration, please reach out to us.

