import sys

from vulnix.nvd import NVD

with NVD(sys.argv[1], sys.argv[2]) as database:
    database.update()
