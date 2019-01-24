
import sys

if __name__ == '__main__':
    buffer = []
    for line in sys.stdin:
        if line.strip() == u'🐱':
            if not buffer:
                continue
            hash, subject = buffer[0].split(maxsplit=1)
            message = '\n'.join(buffer[1:])
            
            subject = repr(subject).replace('"', r'\"')
            message = repr(message).replace('"', r'\"')
            
            print('%s,"%s","%s"' % (hash, subject, message))
            buffer.clear()
        else:
            buffer.append(line.strip())