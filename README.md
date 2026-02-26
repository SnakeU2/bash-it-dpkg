# bash-it-dpkg

Debian package for system-wide installation of [Bash-it](https://github.com/Bash-it/bash-it), a popular framework for managing your Bash configuration.

This package enables:
- Centralized installation in `/opt/bash-it`
- Per-user activation via `bashitctl`
- Safe and clean integration into Debian-based systems
- Easy maintenance in multi-user environments

> 🔗 Upstream project: [https://github.com/Bash-it/bash-it](https://github.com/Bash-it/bash-it)

---

## 📦 Download the Latest .deb Package

The prebuilt package is available via GitHub Releases:

🔗 **[Download bash-it-dpkg_1.0.1_all.deb](https://github.com/SnakeU2/bash-it-dpkg/releases/download/v1.0.1/bash-it-dpkg_1.0.1_all.deb)**

Or install directly from the command line:

```
wget https://github.com/SnakeU2/bash-it-dpkg/releases/download/v1.0.0/bash-it-dpkg_1.0.0-1_all.deb
sudo dpkg -i bash-it-dpkg_1.0.0-1_all.deb
sudo apt-get install -f  # Fix missing dependencies if any

```

💡 Replace version in URL to match the latest release.

🛠 How to Install
Ensure Git is installed (required for Bash-it functionality):

```
sudo apt install -y git

```

Install the downloaded package:

```

sudo dpkg -i bash-it-dpkg_*.deb
sudo apt-get install -f

```

🔌 Activate and Deactivate
Activate for Current User


```

bashitctl activate

```

💡 This creates ~/.bash_it/enable. Changes apply at next login.

To apply immediately:

```

source /etc/profile

```
Now manage components using the original bash-it command:

```

bash-it enable alias/general
bash-it enable plugin/git
bash-it theme powerline-plus

```
Deactivate

```

bashitctl deactivate

```

❗ Disables bash-it for future sessions.
Current shell remains unchanged.

🧱 How to Clone and Build from Source

1. Clone the Repository

```

git clone https://github.com/SnakeU2/bash-it-dpkg.git
cd bash-it-dpkg

```

2. Install Build Dependencies

```

sudo apt install -y devscripts debhelper git

```

3. Build the Package directly

The build process now includes all necessary preparation steps:

- Clones the upstream repository if not present
- Updates it if already cloned
- Cleans up `.git`, `docs`, and screenshots
- Resolves problematic symlinks

Simply run:

```
make build NEW_VERSION=1.0.2-1
```

The package will be built with the new version, and the output files will appear in the parent directory:

```
../bash-it-dpkg_1.0.2-1_all.deb
../bash-it-dpkg_1.0.2-1.dsc
../bash-it-dpkg_1.0.2-1.changes
```

📚 Documentation
man 7 bash-it-dpkg — full package reference
bashitctl --help — activation control
bash-it help — component management after activation
