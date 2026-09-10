from pathlib import Path
import logging
import os
import shutil
import argparse
import getpass
import platform




logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)

install_configs_path = Path("configs/install")
home = Path.home()
insert = ".mylz"
CONFIG_PATHS_FILE = "config_paths.txt"

IMPORT_LINES = {
    ".vimrc": f"source ~/{insert}.vimrc",
    ".bashrc": f"source ~/{insert}.bashrc",
    ".tmux.conf": f"source-file ~/{insert}.tmux.conf",
}

def get_user_config_dir() -> Path:
    computer_name = platform.node()
    username = getpass.getuser()

    return Path("configs") / f"{computer_name}_{username}"

def create_config_paths_empty() -> Path:
    config_dir = get_user_config_dir()
    config_dir.mkdir(parents=True, exist_ok=True)
    config_paths_file = config_dir / "config_paths.txt"
    config_paths_file.touch(exist_ok=True)
    return config_paths_file

def sync():
    configs_path = create_config_paths_empty()
    with open(configs_path) as f:
        lines = f.readlines()
    #    print(lines)

    # print(f"lines len: {len(lines)}")
    if len(lines) == 0:
        print(f"no configs to backup {lines} in {configs_path}")

    for line in lines:
        source_config_path_str = line.strip()
        source_config_path = Path(source_config_path_str).expanduser()

        if source_config_path.exists():
        # verify that is valid path and file exits
            destination_path = get_user_config_dir()/source_config_path.name
            print(f"copy from {source_config_path} to {destination_path}")
            shutil.copy2(source_config_path, destination_path)
        else:
            logger.warning(f"source_config_path: {source_config_path}  does not exist")


def install():
    create_config_paths_empty()
    for config in install_configs_path.iterdir():
        if not config.is_file():
            continue

        destination = home / f"{insert}{config.name}"

        # Don't overwrite an existing config
        if not destination.exists():
            shutil.copy2(config, destination)
            logger.info(f"Copied {config} -> {destination}")
        else:
            logger.warning(f"Already exists: {destination}")

        import_with = IMPORT_LINES.get(config.name)
        # print(import_with)

        if import_with is not None:
            target_config = home / config.name
            # print("import_with is not None")

            # Create the target config if it doesn't exist
            if not target_config.exists():
                logger.info(f"Creating {target_config}")
                target_config.touch()

            # Only append if the import isn't already present
            content = target_config.read_text()
            # print(content)

            if import_with not in content:
                with target_config.open("a") as f:
                    f.write(f"\n{import_with}\n")
                logger.info(f"Added import to {target_config}: {import_with}")
            else:
                logger.info(f"Import already exists in {target_config}")
        # todo at end do source 
            


def uninstall():
    for config_name, import_line in IMPORT_LINES.items():
        my_config = home / f"{insert}{config_name}"
        target_config = home / config_name

        # Remove the copied ~/.mylz* config
        if my_config.exists():
            if my_config.is_file():
                my_config.unlink()
                logger.info(f"Removed {my_config}")
            else:
                logger.warning(f"Not a file, skipping: {my_config}")
        else:
            logger.info(f"Does not exist: {my_config}")

        # Remove the import line from ~/.vimrc, ~/.bashrc, etc.
        if not target_config.exists():
            logger.info(f"Does not exist: {target_config}")
            continue

        content = target_config.read_text()

        if import_line not in content:
            logger.info(f"Import not found in {target_config}")
            continue

        # Remove the line while preserving the rest of the file.
        lines = content.splitlines(keepends=True)
        new_lines = [line for line in lines if line.strip() != import_line]

        target_config.write_text("".join(new_lines))
        logger.info(f"Removed import from {target_config}: {import_line}")

        # todo at end do source 


MAPPING = {
    "sync": sync,
    "install": install,
    "uninstall": uninstall,
}

if __name__ == "__main__":
    # usage scriptname.py sync  calls sync()
    # usage scriptname.py install calls install()
    # usage scriptname.py uninstall calls uninstall()
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "command",
        choices=MAPPING,
        help="Command to run",
    )

    args = parser.parse_args()

    MAPPING[args.command]()