# -*- coding: utf-8 -*-

import os
import subprocess

busybox = "busybox.exe"
bb_path = os.path.abspath(busybox)
#print(bb_path)
bb_dir = os.path.split(bb_path)
#print(bb_dir)
cmd_list = []
cmds = subprocess.Popen([bb_path, '--list'], stdout=subprocess.PIPE)
out, err = cmds.communicate()
for cmd in out.splitlines():
    cmd_list.append(cmd)

for fn in cmd_list:
    file_name = b'bb-' + fn + b'.bat'
    file_content = b'@%~dp0' + busybox.encode('ascii') + b' ' + fn + b' %*'
    with open(file_name.decode('ascii'), 'w') as f:
        f.write(file_content.decode('ascii'))
