COPY C:\SRC\CRTINDEX\BIN\CRTINDEX.EXE CRTINDEX.EXE

C:\VBDOS\ISAMIO /I editions.csv TOP2000.DAT editions editions.txt /C > OUTPUT.TXT
C:\VBDOS\ISAMIO /I listings.csv TOP2000.DAT listings listings.txt /C >> OUTPUT.TXT
C:\VBDOS\ISAMIO /I tracks.csv TOP2000.DAT tracks tracks.txt /C >> OUTPUT.TXT

CRTINDEX.EXE

EXIT