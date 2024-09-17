# zipandbackup.sh

VPS and self hosting backups helper.

Quickly zip given directory from ssh host and download the file locally.

## Requirements

`zip` must be installed on the remote host.

It's advised to connect to the host via an ssh key-based authentication.

## Usage

```
zipandbackup.sh [flag]
zipandbackup.sh [user@]host remote_dir local_dir backup_filename
```

`remote_dir` and `local_dir` must be directories, not files. `backup_filename` can be written with or without the `.zip` extension.

## Flags
`-s`, `--cheatSheet`  : show known pathes defined in the cheatSheet() function of the script

`-h`, `--help`        : show help message

## Examples

```
./zipandbackup.sh app.la-map.com /var/lib/docker/volumes/postgres_data ~/Documents lamap-postgres_data-240811
./zipandbackup.sh clucien@columbo.app /var/lib/docker/volumes/ /root/backups/ columbo-volumes-240811.zip
```
