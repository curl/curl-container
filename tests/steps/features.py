import re

from behave import given


def cleanup_output(data):
    """strip output of ansi esc sequences (e.g. color codes)."""
    ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")
    return ansi_escape.sub("", data)

@given('running > podman run -it {image} curl -V')
def invoke_podman_image_vflag(context, image):
    import subprocess
    cmd = ["podman", "run", "-it", image, "curl", "-V"]
    p = subprocess.run(cmd, capture_output=True, text=True, check=False)
    assert p.returncode == 0

@given('running > podman run -it {image} -V')
def invoke_podman_image(context, image):
    import subprocess
    cmd = ["podman", "run", "-it", image, "-V"]
    p = subprocess.run(cmd, capture_output=True, text=True, check=False)
    assert p.returncode == 0
