#!/usr/bin/python

import os
import re
import StringIO
import sys

from optparse import OptionParser

import color

TAGTYPE_WIDTH = 1
TAG_WIDTH = 8
PROCESS_WDITH = 5

retag = re.compile("^\d\d-\d\d (\d\d:\d\d:\d\d\.\d\d\d) ([A-Z])/([^\(]+)\(([^\)]+)\): (.*)$")

LATEST_USED_TAG_COLOR = [
    color.RED,
    color.GREEN,
    color.YELLOW,
    color.BLUE,
    color.MAGENTA,
    color.CYAN,
    color.WHITE
]

LATEST_USED_PROCESS_COLOR = [
    color.RED,
    color.MAGENTA,
    color.YELLOW,
    color.GREEN,
    color.BLUE
]

CACHED_PROCESS_COLOR = dict()
CACHED_PROCESS = []


KNOWN_TAGS = {
    "Process": color.BLUE,
    "System.err": color.GREEN,
    "AndroidRuntime": color.RED,
}

TAGTYPES = {
    "V": "%s%s%s " % (color.format(fg=color.BLACK, bg=color.WHITE), "V".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "D": "%s%s%s " % (color.format(fg=color.BLUE, bg=color.WHITE), "D".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "I": "%s%s%s " % (color.format(fg=color.GREEN, bg=color.WHITE), "I".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "W": "%s%s%s " % (color.format(fg=color.YELLOW, bg=color.WHITE), "W".center(TAGTYPE_WIDTH), color.format(reset=True)),
    "E": "%s%s%s " % (color.format(fg=color.RED, bg=color.WHITE), "E".center(TAGTYPE_WIDTH), color.format(reset=True)),
}

def cache_color_for_process(pid):
    if not pid in CACHED_PROCESS_COLOR:
        color = LATEST_USED_PROCESS_COLOR[0]
        CACHED_PROCESS_COLOR[pid] = color
        LATEST_USED_PROCESS_COLOR.remove(color)
        LATEST_USED_PROCESS_COLOR.append(color)
    return CACHED_PROCESS_COLOR[pid]

def cache_color_for_tag(tag):
    # this will allocate a unique format for the given tag
    # since we dont have very many colors, we always keep track of the LRU
    if not tag in KNOWN_TAGS:
        KNOWN_TAGS[tag] = LATEST_USED_TAG_COLOR[0]
    cor = KNOWN_TAGS[tag]
    LATEST_USED_TAG_COLOR.remove(cor)
    LATEST_USED_TAG_COLOR.append(cor)
    return cor

def color_text(text, cor):
    return "%s%s%s" % (color.format(fg=cor), text, color.format(reset=True))

def process_line(linebuf, line, ignore_tags, check_process=True):
    global TAG_WIDTH
    match = retag.match(line)
    if not match is None:
        time, tagtype, tag, owner, message = match.groups()
        owner = owner.strip()
        tag = tag.strip()
        if (check_process and int(owner) not in CACHED_PROCESS) or tag in ignore_tags:
            return
        TAG_WIDTH = max(len(tag), TAG_WIDTH)
        # write time
        linebuf.write(color_text(time, color.YELLOW))
        # write owner
        proccess_color = cache_color_for_process(owner)
        linebuf.write(color_text(owner.rjust(PROCESS_WDITH), proccess_color))
        linebuf.write(" ")
        tag_color = cache_color_for_tag(tag)
        tag = tag[-TAG_WIDTH:].rjust(TAG_WIDTH)
        linebuf.write(color_text(tag, tag_color))
        linebuf.write(" ")
        linebuf.write(TAGTYPES[tagtype])
        linebuf.write(message)
        line = linebuf.getvalue()
        linebuf.truncate(0)
        print(line)

def array_argument_parser(option, opt, value, parser):
    arr = getattr(parser.values, option.dest, None)
    if not arr:
        arr = []
        setattr(parser.values, option.dest, arr)
    arr.append(value)

parser = OptionParser()
parser.add_option("-p", "--package", dest="package", metavar="package", help="monitor specified package")
parser.add_option("-a", "--all", dest="all_process", action="store_true", default=False, metavar="package", help="monitor all process")
parser.add_option('-i', '--ignore', dest="ignore_tags", type="string", action='callback', callback=array_argument_parser, metavar="tag", help="ignore specified tag")

(options, args) = parser.parse_args()

input = None
def start_adb():
    global input
    if os.isatty(sys.stdin.fileno()):
        input = os.popen("adb logcat -v time")
    else:
        # reopen fd to avoid stdin bufferring.
        # see http://stackoverflow.com/questions/3670323/setting-smaller-buffer-size-for-sys-stdin
        input = os.fdopen(sys.stdin.fileno(), 'r', 1)

if __name__ == "__main__":
    package = options.package
    all_process = options.all_process
    ignore_tags = options.ignore_tags
    check_process = True
    if package:
        result = os.popen('adb shell ps|grep {0}|awk "{{print \$2,\$9}}"'.format(package)).readlines()
        if not result:
            print("can't find any process match {}".format(color_text(package, color.RED)))
            exit()
        for line in result:
            parts = line.split(' ')
            if len(parts) < 2 or int(parts[0].strip()) <= 0 :
                continue
            if not all_process and parts[1].strip() == package:
                CACHED_PROCESS.append(int(parts[0].strip()))
        if not CACHED_PROCESS:
            print("process {} not match in {}".format(color_text(package, color.RED), color_text(', '.join([p.split(' ')[1].strip() for p in result]), color.GREEN)))
            exit()
    else:
        check_process = False

    if 0:
        print(CACHED_PROCESS)
        print(options)
        exit()

    start_adb()
    linebuf = StringIO.StringIO()
    while True:
        process_line(linebuf, input.readline(), ignore_tags, check_process)
