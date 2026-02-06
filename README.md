# bash-it-dpkg

Debian package for system-wide installation of [Bash-it](https://github.com/Bash-it/bash-it), a popular framework for managing your Bash configuration.

This package enables:
- Centralized installation in `/opt/bash-it`
- Per-user activation via `bashitctl`
- Safe and clean integration into Debian-based systems
- Easy maintenance in multi-user environments

> 🔗 Upstream project: [https://github.com/Bash-it/bash-it](https://github.com/Bash-it/bash-it)

---

## 📦 Where to Get the .deb Package

The package is not yet published in public repositories. You can obtain it as follows:

### Option 1: Build from Source (Recommended)
See [How to Clone and Build from Source](#how-to-clone-and-build-from-source)

### Option 2: CI/CD Artifacts
If GitHub Actions or another CI system is configured, check the **Actions → Artifacts** or **Releases** tab on GitHub.

---

## 🛠 How to Install

Ensure build dependencies are installed:

```bash
sudo apt install -y git
Install the package:

bash
sudo dpkg -i bash-it-dpkg_*.deb
sudo apt-get install -f  # Fix missing dependencies if needed
🔌 Activate and Deactivate
Activate for Current User
bash
bashitctl activate
💡 This creates ~/.bash_it/enable. Changes apply at next login.

To apply immediately:

bash
source /etc/profile
Now manage components using the original bash-it command:

bash
bash-it enable alias/general
bash-it enable plugin/git
bash-it theme powerline-plus
Deactivate
bash
bashitctl deactivate
❗ Disables bash-it for future sessions.
Current shell remains unchanged.

🧱 How to Clone and Build from Source
1. Clone the Repository
bash
git clone https://github.com/SnakeU2/bash-it-dpkg.git
cd bash-it-dpkg
2. Install Build Dependencies
bash
sudo apt install -y devscripts debhelper git
3. Prepare Build Environment
bash
./setup.sh
This script:

Clones upstream bash-it into opt/bash-it/
Resolves symbolic links that break dpkg-source
Removes unnecessary files (docs, .git)
Ensures clean, reproducible source tree
4. Build the Package
bash
debuild -us -uc
Output packages will appear in the parent directory:

text
../bash-it-dpkg_*.deb
../bash-it-dpkg_*.dsc
../bash-it-dpkg_*.changes
📚 Documentation
man 7 bash-it-dpkg — full package reference
bashitctl --help — activation control
bash-it help — component management after activation
🤝 Author
Alexey Abrosimov
Email: alexey.abrosimov@example.com
GitHub: @SnakeU2


---
