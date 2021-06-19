import subprocess
import sys

def run(cmd):
    proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
    stdout, stderr = proc.communicate()

    return proc.returncode, stderr

retcode, err = run(["dialog", "--checklist", "Choose toppings:", "10", "40", "3", "1", "Cheese", "on", "2", "Tomato Sauce", "on", "3", "Anchovies", "off"])

print("err: '{}'".format(err))
for s in err.decode().split():
    print("test %s" % s)
print("exit: {}".format(retcode))
