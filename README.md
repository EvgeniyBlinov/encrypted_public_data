[![MIT License][license-image]][license-url]

Encrypted public data
================

### Dependencies

- bash
- openssl
- curl (get_data.sh)
- ssh-keygen (keygen.sh)

For tests only

- docker

### Commands

`bin/crypt.sh e ssh_loopback` - encrypt data

`for data in $(ls -1 data);do bin/crypt.sh e $data; done`  - encrypt all data

`bin/crypt.sh d ssh_loopback ./keys/vendor/key` - test data

`bin/get_data.sh ssh_loopback` - get encrypted data

### @TODO

- jump server - vagrant virtual machine for port forwarding to destination machine
- `data/jump_server`
- make live usb for install
- make live usb connect to `data/jump_server`

## License

[![MIT License][license-image]][license-url]

## Author

- [Blinov Evgeniy](mailto:evgeniy_blinov@mail.ru) ([http://blinov.in.ua/](http://blinov.in.ua/))

[license-image]: http://img.shields.io/badge/license-MIT-blue.svg?style=flat
[license-url]: LICENSE
