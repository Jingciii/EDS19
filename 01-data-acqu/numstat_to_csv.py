import sys

def print_buffer(buffer):
    hash = buffer[0]
    for statline in buffer[1:]:
        if not statline:
            continue
        added, deleted, path = statline.split(maxsplit=2)
        print('"%s",%s,%s,"%s"' % (hash, added, deleted, path))

if __name__ == '__main__':
    buffer = []
    for line in sys.stdin:
        if line.strip() == u'🐱':
            if not buffer:
                continue
            print_buffer(buffer)
            buffer.clear()
        else:
            buffer.append(line.strip())