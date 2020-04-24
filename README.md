# looktxt
Convert any free format text file with numerical areas into scientific data formats

Description
---
This program searches for numerical fields in a text file, whatever be its formating, and export all numerics. 
Data sets (scalar, vector, matrix) are given unique names, based on file content. Results can be generated for e.g. Matlab, IDL, Scilab, Octave, XML, HTML, NeXus/HDF5... 

This utility avoids scientists to write load routines for each text data format they want to analyze.

NOTE: if you wish to process the data faster, work on the ```/dev/shm``` shared ramdisk on a Linux box.

Installation
---
This program is a pure C code, with no dependency. Just compile and install it with:
```bash
make
sudo make install
```

You may as well compile it manually with:
```bash
cc -O2 looktxt.c -o looktxt
```

Usage
----
Extracting data from a text file is a never ending story. Usually,  one
will  write a short script or program/function to analyse each specific
input data format. The looktxt command purpose is to read any text data
file containing numerical blocks just as a human would read it. Specif‐
ically, it looks for contiguous numerical blocks, which are stored into
matrices,  and  other parts of the input file are classified as headers
which are optionally exported. Numerical blocks are labelled  according
to the preceeding header block last word.

Blocks  read  from the data file can be sorted into sections. Each sec‐
tion SEC starts when it appears in a header and contains all  following
fields  until a new section is found or the end of the file.  Addition‐
ally, one may search for specific metadata keywords, at user's  choice.
Each  data field matching the keyword metadata META in its headers will
create a new entry in the MetaData section.

The output data files may be generated using "Matlab", "Scilab", "IDL",
"Octave",  "XML",  "HTML",  "NeXus/HDF" and  "Raw"  formats  (using  the  -f FORMAT
option), using a structure-like hierarchy. This hierarchy contains  all
sections,  metadata  and optionally headers that have been found during
the parsing of the input data file.

After using looktxt foo the data is simply  loaded  into  memory  using
e.g.  'matlab> ans=foo;' or directly with "matlab> looktxt('foo')". The
exact method to import data is indicated at the begining of the  output
data file, and depends on the format.

The  command  can handle large files within a very short time, with minimal memory requirements.

Use ```looktxt -h``` to identify available output formats, and the default one (e.g. Matlab/Octave).

Syntax
---
```
looktxt  [-b][-c][-f  FORMAT][-H][-s  SEC ...][-m META ...] file1 file2 ...
```

with the following main options:

 ```-h | --help```
        displays the command help

 ```-b | --binary```
        sets binary mode for large numerical blocks (more than 100  ele‐
        ments). This option creates an additional '.bin' file to be read
        accordingly to the references indicated for each  field  in  the
        output  text  data file. This is transparently done when reading
        output files with matlab(1), scilab(1), idl(1), and octave(1).

 ```-c | --catenate```
        Catenates similar numerical fields (which  have  similar  dimen‐
        sions and names)

 ```-F | --force```
        Overwrites existing files

 ```-f FORMAT | --format=FORMAT```
        Sets the output format for generated files

 ```--fortran | --wrapped```
        Catenates  single  wrapped  output  lines with previous matrices
        (e.g. caused by the 80 chars per line limit in old data  formats
        written by fortran codes)

 ```-H | --headers```
        Extracts headers for each numerical field (recommended)

 ```-s SEC | --section=SEC ...```
        Classifies  fields  into sections matching word SEC. This option
        can be repeated

 ```-m META | --metadata=META ...```
       Extracts lines containing word  META  as  user  metadata.   This
        option can be repeated

And other less used options:

 ```--fast```
 When numerical data blocks only use isspace(3) separators (\n \r
        \f \t \v and space), the reading can be made  faster  with  even
        lower memory requirements.

``` --silent```
        Silent mode, to only display fatal errors

 ```--verbose | -v | --debug```
        To display plenty of informations

 ```--makerows=NAME ...```
        When  a numerical data block label matching NAME is found, it is
        transformed into a row vector. This  may  be  used  for  wrapped
        files (--fortran option). This option can be repeated

``` -o FILE | --outfile=FILE```
        to use FILE as output file. The streams stdout and stderr may be
        used, but we then recommend to specifiy the --silent  option  to
        avoid unwanted messages in the output.
        
Examples
---
Typical usage (exporting headers as well, default output as Matlab/Octave script)
```
looktxt --headers foo
```

For  large data files (using binary float storage, catenate and fortran
 mode)
```
looktxt --force --catenate --headers --binary --fortran foo
```

Sorting data into sections, and searching a metadata keyword
```
looktxt --section SEC1 --section SEC2 --metadata META1 --headers foo
```

will result in the following Matlab structure:

```
      Creator: 'Looktxt 1.0.8 24 Sept 2009 Farhi E. [farhi at ill.fr]'
         User: 'farhi on localhost'
       Source: 'foo'
         Date: 'Fri Dec 12 11:35:20 CET 2008'
       Format: 'Matlab'
      Command: [1x195 char]
     Filename: 'foo.m'
      Headers: struct SEC1, struct SEC2, struct MetaData (headers)
         Data: struct SEC1, struct SEC2, struct MetaData (numerics)
```

License
---
GPL-2

Author
---
Emmanuel FARHI <emmanuel.farhi@synchrotron-soleil.fr> 1997-2019
