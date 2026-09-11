# Development

## Project configuration

- App type: Watch App
- Initial target: Forerunner 965 (`fr965`)
- Minimum Connect IQ API: 4.2.0
- Language: Monkey C

## Setup

Install the Connect IQ SDK, Forerunner 965 device support, and Java 11 or
newer. Visual Studio Code with the Monkey C extension can run SDK commands;
LazyVim can remain the primary editor.

In VS Code:

1. Run `Monkey C: Verify Installation`.
2. Run `Monkey C: Generate a Developer Key` if needed.
3. Open a `.mc` file under `source/`.
4. Use `Run > Run Without Debugging` and select the Forerunner 965 simulator.

## Command-line build

```bash
mkdir -p bin

monkeyc \
  -d fr965 \
  -f monkey.jungle \
  -o bin/HeroSet.prg \
  -y /path/to/developer_key
```

Launch the simulator with `connectiq`, then run the compiled app:

```bash
monkeydo bin/HeroSet.prg fr965
```

`Build for Device` compiles the app. `Run > Run Without Debugging` launches it
in the simulator.

## Signing key safety

The developer key signs the application and is required for future updates.
Keep it private and backed up. Never commit it, upload it, or include it in
screenshots or archives. The repository ignores `developer_key`, `.der`, and
`.pem` files.

For a shared or public checkout, store the key outside the repository, for
example:

```text
~/.garmin-connectiq/keys/developer_key.der
```

Keep using the same key for every Store update. Losing it prevents updates to
the published app.
