#include "ruby.h"

static VALUE fhw_greet(VALUE slef) {
  return rb_str_new_cstr("Hello, World!");
}

void Init_hello_world(void) {
  VALUE cHelloWorld = rb_define_class("HelloWorld", rb_cObject);

  rb_define_method(cHelloWorld, "greet", fhw_greet, 0);
}
