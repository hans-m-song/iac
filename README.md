# aws

Managed AWS CDK stack with minimal interact CLI.

## Usage

Note: include the environment variable `DEBUG=true` to see additional debug output.

### Interactive

```
$ npm run start

> start
> tsx stacks/index.ts

Listing available stacks...
╔═══════════════════════╗
║ Available stacks      ║
╟───┬───────────────────╢
║ 0 │ EKSConnectorAgent ║
╟───┼───────────────────╢
║ 1 │ HostedZoneUpdate  ║
╚═══╧═══════════════════╝

Select a stack (0-1)
> 0
╔══════════════╗
║ Actions      ║
╟───┬──────────╢
║ 0 │ synth    ║
╟───┼──────────╢
║ 1 │ describe ║
╟───┼──────────╢
║ 2 │ deploy   ║
╚═══╧══════════╝

Select an action (0-2)
> 2
Beginning synth...
Beginning deploy...
...
```

### Subcommands

```
$ npm run start EKSConnectorAgent synth

> start
> tsx stacks/index.ts "EKSConnectorAgent" "synth"

Listing available stacks...
Notice: selected stack exists
Beginning synth...
```
