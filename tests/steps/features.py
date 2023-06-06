import json
import re

from behave import given, then

def cleanup_output(data):
    """strip output of ansi esc sequences (eg. color codes)"""
    ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")
    return ansi_escape.sub("", data)

@given(u'a set of container images')
def step_impl(context):
    data = getattr(context, "data", None)
    if not data:
        context.data = {}
        context.data["images"] = []
    for row in context.table:
        context.data["images"].append(row["image"])

@then(u'running > podman run -it {image} -V')
def invoke_podman_image(context, image):
    import subprocess
    cmd = f"podman run -it {image} -V".split()
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    out, err = p.communicate()
    print(err)

