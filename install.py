#! /usr/bin/python

import enum
import os
import subprocess
import sys

HOME = os.path.expanduser("~")
SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))

class LinkStatus(enum.Enum):
    NOT_EXIST = 0
    LINK = 1
    LINK_OTHER = 2
    NOT_LINK = 3


def run1(cmd, cwd=None):
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    stdout, stderr = proc.communicate()
    return proc.returncode, stdout, stderr

def run2(cmd, cwd=None):
    proc = subprocess.Popen(cmd, stdout=None, stderr=subprocess.PIPE, cwd=cwd)
    stdout, stderr = proc.communicate()
    return proc.returncode, stderr

def find(cwd):
    retcode, stdout, stderr = run1(["find", "-type", "f", "-or", "-type", "l"], cwd=cwd)
    if retcode != 0:
        raise Exception("failed to find config files")
    return stdout.decode().split()

def link(src, dst, status):
    if status == LinkStatus.NOT_LINK:
        # if file exists, backup first
        run1(["cp", dst, dst + ".bak"])
    retcode, stdout, stderr = run1(["ln", "-sf", src, dst])
    if retcode != 0:
        raise Exception(f"failed to link {src} to {dst}")
    return


def get_src_path(filename):
    return os.path.abspath(os.path.join(SCRIPT_DIR, "home", filename))

def get_dst_path(filename):
    return os.path.abspath(os.path.join(HOME, filename))

def readlink(filepath):
    retcode, stdout, stderr = run1(["readlink", filepath])
    if retcode == 0:
        return stdout.decode().strip()
    else:
        return None

def get_link_status(filename):
    """Check link status of filename, returns LinkStatus"""
    src_path = get_src_path(filename)
    link = readlink(get_dst_path(filename))
    if link == src_path:
        return LinkStatus.LINK
    if link != None:
        return LinkStatus.LINK_OTHER
    if os.path.exists(os.path.join(HOME, filename)):
        return LinkStatus.NOT_LINK
    return LinkStatus.NOT_EXIST

def link_status_to_desc(st):
    if st == LinkStatus.LINK_OTHER:
        return " (linked elsewhere)"
    if st == LinkStatus.NOT_LINK:
        return " (exists but not link)"
    return ""

def dialog_checklist(text, height, width, items):
    checklist = [[str(i), it[0] + link_status_to_desc(it[1]), "on" if it[1] == LinkStatus.LINK else "off"] for i, it in enumerate(items)]
    checklist_flat = [it for sublist in checklist for it in sublist]
    retcode, err = run2(["dialog", "--checklist", text, str(height), str(width), str(len(items))] + checklist_flat)
    if retcode != 0:
        return False
    return [int(s) for s in err.decode().split()]

def dialog_yesno(msg, height, width):
    retcode, err = run2(["dialog", "--yesno", msg, str(height), str(width)])
    return retcode == 0

def clear():
    os.system("clear")
    return

def main():
    config_files = [(f[2:], get_link_status(f)) for f in find(os.path.join(SCRIPT_DIR, "home"))]
    selected = dialog_checklist("Select config files to link", 20, 80, config_files)
    action_list = []
    msg_list = []

    if selected:
        for idx in selected:
            filename = config_files[idx][0]
            status = config_files[idx][1]
            if status == LinkStatus.LINK:
                pass
            else:
                src_path = get_src_path(filename)
                dst_path = get_dst_path(filename)
                action_list.append((src_path, dst_path, status))
                msg_list.append(src_path + " -> " + dst_path + link_status_to_desc(status))

        msg = "Are you sure to create the following links?\n\n" + "\n".join(msg_list)
        ret = dialog_yesno(msg, 20, 80)
        if ret:
            for src, dst, status in action_list:
                link(src, dst, status)

    clear()
    for src, dst, status in action_list:
        print(src + " -> " + dst)

if __name__ == "__main__":
    main()
