# Backup Box

Bash shell scripts that transform a Raspberry Pi (or any single-board computer running a Debian-based Linux distribution) into an inexpensive, fully-automatic, pocketable files backup device.

The project is based on the [Little Backup Box](https://github.com/dmpop/little-backup-box) created by Dmitri Popov.

## Installation

1. Copy `backup.sh`, `install.sh` and `remove.sh` to one catalog on your Raspberry Pi
2. Run `chmod +x install.sh` command to make `install.sh` file executable
3. Run `./install.sh`
4. You can remove `backup.sh`, `install.sh` and `remove.sh` files

## Uninstallation

1. Go to `~/.backup-box`
2. Run `./remove.sh`

## Usage

1. Boot the Raspberry Pi (LED: `heartbeat`)
2. Plug in the backup storage device (LED: `blink, 1000ms on`)
3. Plug in the storage with files you want to copy (LED: `blink, 500ms on` then change to `blink, 250ms on, 250ms off``)
4. Wait till the Raspberry Pi shutdown (LED: `off`)

# Additional information

If you connect the HDD to the Raspberry Pi you can need add this `max_usb_current=1` to `/boot/config.txt` file.
You do it at your own risk!

## License

The [GNU General Public License version 3](http://www.gnu.org/licenses/gpl-3.0.en.html)
