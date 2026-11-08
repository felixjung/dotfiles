"""Exercise chezmoi's Rex import against an isolated macOS defaults domain."""

import json
import os
from pathlib import Path
import plistlib
import shutil
import subprocess
import sys
import tempfile
import unittest
import uuid


REPO = Path(__file__).resolve().parents[3]
SCRIPT = ".chezmoiscripts/run_onchange_after_darwin-rex-settings.sh.tmpl"
SNAPSHOT = "dot_config/rex/private_gui-settings.plist"


@unittest.skipUnless(sys.platform == "darwin", "requires macOS User Defaults")
class PreferencesTest(unittest.TestCase):
    def test_apply_imports_settings_and_preserves_local_state(self):
        self.assertTrue((REPO / SCRIPT).exists(), "Rex preferences import is missing")
        domain = "com.superlogical.rex.chezmoi-test-" + uuid.uuid4().hex
        env = dict(os.environ)
        env["PATH"] = "/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:" + env.get("PATH", "")

        def run(*args):
            return subprocess.run(args, env=env, check=True, capture_output=True)

        def preferences():
            return plistlib.loads(run("/usr/bin/defaults", "export", domain, "-").stdout)

        try:
            with tempfile.TemporaryDirectory(prefix="rex-preferences-") as tmp:
                root = Path(tmp)
                source = root / "source"
                target = root / "target"
                (source / SCRIPT).parent.mkdir(parents=True)
                (source / SNAPSHOT).parent.mkdir(parents=True)
                target.mkdir()
                # Run the real template and apply lifecycle; only its domain is isolated.
                (source / SCRIPT).write_text(
                    (REPO / SCRIPT).read_text().replace("com.superlogical.rex", domain)
                )
                shutil.copyfile(REPO / SNAPSHOT, source / SNAPSHOT)
                config = root / "config.json"
                config.write_text(json.dumps({"data": {}}))
                apply = [
                    shutil.which("chezmoi"), "--config", str(config),
                    "--source", str(source), "--destination", str(target),
                    "--persistent-state", str(root / "state.boltdb"),
                    "--cache", str(root / "cache"), "apply",
                ]
                run("/usr/bin/defaults", "write", domain, "RuntimeState", "-string", "keep")
                run(*apply)
                saved = plistlib.loads((source / SNAPSHOT).read_bytes())
                actual = preferences()
                for key, value in saved.items():
                    self.assertEqual(actual[key], value, key)
                self.assertEqual(actual["RuntimeState"], "keep")

                # An unchanged snapshot must leave later manual app edits alone.
                run("/usr/bin/defaults", "write", domain,
                    "Workspace.terminalFontName", "-string", "Manual Font")
                run(*apply)
                self.assertEqual(preferences()["Workspace.terminalFontName"], "Manual Font")

                # A changed snapshot must trigger the import, even if the script is unchanged.
                saved["Workspace.terminalFontName"] = "Updated Font"
                (source / SNAPSHOT).write_bytes(plistlib.dumps(saved))
                run(*apply)
                actual = preferences()
                self.assertEqual(actual["Workspace.terminalFontName"], "Updated Font")
                self.assertEqual(actual["RuntimeState"], "keep")
        finally:
            subprocess.run(["/usr/bin/defaults", "delete", domain], env=env, capture_output=True)


if __name__ == "__main__":
    unittest.main()
