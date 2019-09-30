# csv-diff

diff for CSV


# Description
This tool displays only the difference lines of CSV (TSV) files.
You can also specify to display only the columns with differences.


# Example
- t/data/sample01.csv
```
aaa,bbb,ccc,ddd,eee
fff,ggg,hhh,iii,jjj
```

- t/data/sample02.csv
```
aaa,bbb,ccc,ddd,eee
fff,ggg2,hhh,iii2,jjj
```

- basic
```
$ perl tools/csv_diff.pl t/data/sample01.csv t/data/sample02.csv
LINE:2  fff,ggg,hhh,iii,jjj     fff,ggg2,hhh,iii2,jjj
```

- the columns with differences. 
```
$ perl tools/csv_diff.pl t/data/sample01.csv t/data/sample02.csv -c
LINE:2  ggg     ggg2
LINE:2  iii     iii2
```

# License
Copyright (c)2019 xxxmakotoxxx All rights reserved.

This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself. See perlartistic.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Author
xxxmakotoxxx (https://github.com/xxxmakotoxxx)
