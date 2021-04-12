
<p align="center">
  <a href="">
<img height=125
src="https://raw.githubusercontent.com/akilhylton/helium-quick-wallet/main/.assets/helium-quick-wallet-logo.svg"/>
  </a>
</p>

<p align="center"> 
  <strong> A tool that builds and compiles helium-wallet and saves you time ⚡</strong>
</p>

## Motivation
Are you tired of spending extra time individually running the commands needed to build and complie the [helium-wallet](https://github.com/helium/helium-wallet-rs) repository. Because I defiently am so I built a solution, a small bash script to automate the entire process. With a quick and simple oneliner. This tool will install everything necessary for you to run `foo@bar:~$ helium-wallet`. 

## Installation

```
sudo chmod 755 quick-helium-wallet.sh && ./quick-helium-wallet.sh
```

## Usage

At any time use `-h` or `--help` to get more help for a command.

### Global options

Global options _precede_ the actual command on the command line.

The following global options are supported

* `-f` / `--file` can be used once or multiple times to specify either
  shard files for a wallet or multiple wallets if the command supports
  it. If not specified a file called `wallet.key` is assumed to be the
  wallet to use for the command.

* `--format json|table` can be used to set the output of the command
  to either a tabular format or a json output.

### Create a wallet

```
    helium-wallet create basic
```

The basic wallet will be stored in `wallet.key` after specifying an
encryption password on the command line. Options exist to specify the
wallet output file and to force overwriting an existing wallet.

A `--seed` option followed by space seprated mnemonic words can be
used to construct the keys for the wallet.


### Create a sharded wallet

Sharding wallet keys is supported via [Shamir's Secret
Sharing](https://github.com/dsprenkels/sss).  A key can be broken into
N shards such that recovering the original key needs K distinct
shards. This can be done by passing options to `create`:

```
    helium-wallet create sharded -n 5 -k 3
```

This will create wallet.key.1 through wallet.key.5 (the base name of
the wallet file can be supplied with the `-o` parameter).

When keys are sharded using `verify` will require at least K distinct
keys.

A `--seed` option followed by space seprated mnemonic words can be
used to construct the keys for the wallet.

#### Implementation details

A ed25519 key is generated via libsodium. The provided password is run
through PBKDF2, with a configurable number of iterations and a random
salt, and the resulting value is used as an AES key. When sharding is
enabled, an additional AES key is randomly generated and the 2 keys
are combined using a sha256 HMAC into the final AES key.

The private key is then encrypted with AES256-GCM and stored in the
file along with the sharding information, the key share (if
applicable), the AES initialization vector, the PBKDF2 salt and
iteration count and the AES-GCM authentication tag.


### Public Key

```
    helium-wallet info
    helium-wallet -f my.key info
    helium-wallet -f wallet.key.1 -f wallet.key.2 -f my.key info
```

The given wallets will be read and information about the wallet,
including the public key, displayed. This command works for all wallet
types.

### Displaying

Displaying information for one or more wallets without needing its
password can be done using;


```
    helium-wallet info
```

To display a QR code for the public key of the given wallet use:

```
    helium-wallet info --qr
```

This is useful for sending tokens to the wallet from the mobile
wallet.

### Verifying

Verifying a wallet takes a password and one or more wallet files and
attempts to decrypt the wallet.

The wallet is assumed to be sharded if the first file given to the
verify command is a sharded wallet. The rest of the given files then
also have to be wallet shards. For a sharded wallet to be verified, at
least `K` wallet files must be passed in, where `K` is the value given
when creating the wallet.

```
    helium-wallet verify
    helium-wallet -f wallet.key verify
    helium-wallet -f wallet.key.1 -f wallet.key.2 -f wallet.key.5 verify
```

### Sending Tokens

To send tokens to other accounts use:

```
    helium-wallet pay -p <payee>=<hnt>
    helium-wallet pay -p <payee>=<hnt> --commit

```

Where `<payee>` is the wallet address for the wallet you want to
send tokens to, `<hnt>` is the number of HNT you want to send. Since 1 HNT
is 100,000,000 bones the `hnt` value can go up to 8 decimal digits of
precision.

The default behavior of the `pay` command is to print out what the
intended payment is going to be _without_ submiting it to the
blockchain.  In the second example the `--commit` option commits the
actual payment to the API for processing by the blockchain.


### Environment Variables

The following environment variables are supported:

* `HELIUM_API_URL` - The API URL to use for commands that need API
  access, for example sending tokens.

* `HELIUM_WALLET_PASSWORD` - The password to use to decrypt the
  wallet. Useful for scripting or other non-interactive commands, but
  use with care.
