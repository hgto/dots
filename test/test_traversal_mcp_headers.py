import importlib.util
import os
from pathlib import Path
import tempfile
import threading
import unittest


SKILL_ROOT = Path(__file__).resolve().parents[1] / "default/skills"
SPEC = importlib.util.spec_from_file_location(
    "traversal_headers", SKILL_ROOT / "traversal-mcp-connect/headers-helper.py"
)
HELPER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(HELPER)


class TraversalHeadersTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.mount = Path(self.directory.name) / "mount"

    def write_fifo(self, content):
        os.mkfifo(self.mount)

        def write():
            with self.mount.open("w") as stream:
                stream.write(content)

        writer = threading.Thread(target=write, daemon=True)
        writer.start()
        return writer

    def test_regular_file_is_rejected(self):
        self.mount.write_text("public test fixture")
        with self.assertRaises(ValueError):
            HELPER.read_headers(self.mount)

    def test_symlink_to_fifo_is_rejected(self):
        target = self.mount.with_name("target")
        os.mkfifo(target)
        self.mount.symlink_to(target)
        with self.assertRaises(ValueError):
            HELPER.read_headers(self.mount)

    def test_quoted_value_is_returned_in_memory(self):
        writer = self.write_fifo('export TRAVERSAL_API_KEY="public-test-fixture"\n')
        self.assertEqual(
            HELPER.read_headers(self.mount),
            {"Authorization": "Bearer public-test-fixture"},
        )
        writer.join(timeout=1)
        self.assertFalse(writer.is_alive())

    def test_missing_variable_is_rejected(self):
        self.write_fifo("OTHER_VARIABLE=public-test-fixture\n")
        with self.assertRaises(ValueError):
            HELPER.read_headers(self.mount)

    def test_newline_in_value_is_rejected(self):
        self.write_fifo('TRAVERSAL_API_KEY="invalid\nvalue"\n')
        with self.assertRaises(ValueError):
            HELPER.read_headers(self.mount)

    def test_mount_without_writer_times_out(self):
        os.mkfifo(self.mount)
        with self.assertRaises(TimeoutError):
            HELPER.read_headers(self.mount, timeout=0.05)


if __name__ == "__main__":
    unittest.main()
