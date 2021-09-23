# xc

POSIX-compliant collection of scripts for systems administration.

## Installation

```shell
curl -s https://raw.githubusercontent.com/xordeio/xc/main/xc > /usr/bin/xc && chmod +x /usr/bin/xc
```

## Usage

```shell
Usage:
  xc <short-code>|<code>

  Arguments:

    short-code      
      numeric command short-code
      example: xc 1         
    
    code
      alphanumeric command code
      example: xc update

  Predefined short-codes:
    1 = update
```