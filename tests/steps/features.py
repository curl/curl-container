import json
import re

from behave import given, then

def cleanup_output(data):
    """strip output of ansi esc sequences (eg. color codes)"""
    ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")
    return ansi_escape.sub("", data)

@given(u'running > podman run -it {image} curl -V')
def invoke_podman_image_vflag(context, image):
    import subprocess
    cmd = f"podman run -it {image} curl -V".split()
    p = subprocess.run(cmd,capture_output=True, text=True)
    assert p.returncode == 0

@given(u'running > podman run -it {image} -V')
def invoke_podman_image(context, image):
    import subprocess
    cmd = f"podman run -it {image} -V".split()
    p = subprocess.run(cmd,capture_output=True, text=True)
    assert p.returncode == 0
