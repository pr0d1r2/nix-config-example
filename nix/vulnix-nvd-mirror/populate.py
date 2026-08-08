import sys

from vulnix.nvd import NVD, Vulnerability


_parse_vulnerability = Vulnerability.parse.__func__


def parse_vulnerability(cls, item):
    """Treat malformed NVD records like other records vulnix skips."""
    try:
        return _parse_vulnerability(cls, item)
    except KeyError as error:
        raise ValueError(f"malformed NVD record: missing {error}") from error


Vulnerability.parse = classmethod(parse_vulnerability)

with NVD(sys.argv[1], sys.argv[2]) as database:
    database.update()
