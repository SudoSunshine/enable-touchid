# Enable Touch ID for macOS Terminal

![Shell](https://img.shields.io/badge/shell-bash-yellow.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Jamf Pro](https://img.shields.io/badge/Jamf%20Pro-compatible-orange.svg)

Enables Touch ID authentication for `sudo` commands in Terminal by configuring `/etc/pam.d/sudo_local`. Configuration survives macOS updates.

## Features

- Uses Apple's `sudo_local.template` for update-safe configuration
- Idempotent - safe to run multiple times
- Proper exit codes for Jamf Pro workflow
- Comprehensive logging

## Requirements

- macOS 10.15+ with Touch ID hardware
- Deployed via Jamf Pro policy

## Deployment

**Scripts:** Copy `Enable-TouchID-sudo.sh` to Jamf Pro  
**Policy:** Add script, scope to Touch ID-equipped Macs  
**Execution Frequency:** Ongoing (idempotent)

## What It Does

1. Verifies `/etc/pam.d/sudo_local.template` exists
2. Creates `/etc/pam.d/sudo_local` from template
3. Uncomments `auth sufficient pam_tid.so`
4. Verifies configuration

**File Modified:** `/etc/pam.d/sudo_local`

**Change:**
```diff
# sudo_local: local config file which survives system update and is included for sudo
# uncomment following line to enable Touch ID for sudo
-#auth       sufficient     pam_tid.so
+auth       sufficient     pam_tid.so
```


## Troubleshooting

**Touch ID doesn't work after successful policy execution:**
- New Terminal session required (PAM changes don't affect existing sessions)
- Verify: `cat /etc/pam.d/sudo_local | grep "^auth"`
- Check Touch ID configured: `bioutil -r`

**Template not found:**
- macOS version < 10.15
- Adjust Smart Group scoping

## Why sudo_local?

`/etc/pam.d/sudo` gets overwritten during macOS updates. Apple's `sudo_local` is specifically designed to persist across updates.

## Version History

- **v1.0** (2026-02-09) - Initial release

## License

MIT License - see [LICENSE](LICENSE)

## Author

**Sunshine** - [SudoSunshine](https://github.com/SudoSunshine)

---

**⭐ Star this repo if it helped your deployment**
