(list
  [:p 
    [:a {"href" "files/time.scm"} "Here"]
    " is the scheme source code for a replacement of STk's time function. To run the time code, you must to create a shared library code out of "
    [:a {"href" "files/calc_time.c"} "this"]
    " C source file. To create the library using gcc you can run these two commands to first compile the object file and then create the library:"]
  [:pre 
    "\tgcc -fPIC -c calc_time.c\n"
    "\tgcc -shared -o libcalctime.so calc_time.o"]
  [:p "After you create this library you must change time.scm to load access the library from where you put it. You should change the two lines that start with \"(define-external)\" to do this. This code has been tested on Solaris and Linux with version 4.0.1 of STk, it uses STk specific macro definitions so it will probably not work with any other scheme interpreter."])