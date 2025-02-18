# `etl.masking` Module

## Module Overview

The `etl.masking` module provides functions for encrypting and decrypting datasets using AES-ECB encryption. These functions help in securely storing or transmitting sensitive data by applying AES encryption with a specified Base64-encoded key. The module includes both encryption and decryption capabilities for datasets in the form of records.

## Key Functions

1. **encryptData**  
   Encrypts a dataset using AES-ECB encryption with a given Base64-encoded key. The records are converted to strings before encryption, and the output is a set of Base64-encoded encrypted strings.

2. **decryptData**  
   Decrypts a dataset using AES-ECB decryption with a given Base64-encoded key. The function takes a set of Base64-encoded encrypted strings and converts them back into records of the specified type after decryption.
