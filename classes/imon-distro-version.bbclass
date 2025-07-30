# Custom distro version base on git tag

def run_git(d, cmd):
    import subprocess

    path = d.getVar('IMON_LAYER_PATH', True)
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, cwd=path)
    out, err = proc.communicate()
    if err:
        bb.fatal("Failed execute git command: %s" % cmd)

    return out.decode("utf-8").rstrip()

def imon_distro_version(d):
    cmd = "git describe --tags --abbrev=0"
    git_tag = run_git(d, cmd)
    if not git_tag:
        bb.warn("Unable to get version from git, use default")
        return "1.0.0"

    return git_tag

IMON_VERSION := "${@imon_distro_version(d)}"
