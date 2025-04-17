#! /usr/bin/env python3

# ---------------------------------------------------------
# Automatically updates the CFBundleVersion (build number) in the Info.plist file
# located inside the built app bundle during Xcode build phases.
#
# The build number is derived from the Git revision count of the current HEAD,
# ensuring that each build has a unique, incrementing identifier without the need
# to manually bump or commit version changes to the repository.
#
# If the working directory contains uncommitted changes, a ".locally.modified" suffix
# is appended to the build number for traceability.
#
# Intended for use exclusively within Xcode Run Script build phases.
#
# Author: Adil Yergaliyev <adil.yergaliyev@gmail.com>
# Date: 2025-04-17
# ---------------------------------------------------------

import os.path
import subprocess
import sys

build_dir  = os.environ['BUILT_PRODUCTS_DIR']
plist_path = os.path.join(build_dir, os.environ['INFOPLIST_PATH'])

# Get Git revision count
revision_count = subprocess.check_output(['git', 'rev-list', '--count', 'HEAD']).decode().strip()

# Check for local modifications
has_local_changes = subprocess.check_output(['git', 'status', '--porcelain', '--untracked-files=no']).decode().strip()
suffix = '.locally.modified' if has_local_changes else ''

build_number = revision_count + suffix

# Update CFBundleVersion in Info.plist
result = subprocess.call(['/usr/libexec/PlistBuddy', '-c', "Set :CFBundleVersion " + build_number, plist_path])
print("Updated Info.plist at path '" + plist_path + "' with return code %d." % result)
sys.exit(result)
