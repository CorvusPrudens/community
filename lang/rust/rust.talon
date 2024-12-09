code.language: rust
-
tag(): user.code_comment_line
tag(): user.code_comment_block_c_like
tag(): user.code_comment_documentation

tag(): user.code_imperative
tag(): user.code_object_oriented

tag(): user.code_data_bool
tag(): user.code_data_null

tag(): user.code_functions
tag(): user.code_functions_common
tag(): user.code_libraries
tag(): user.code_libraries_gui

tag(): user.code_operators_array
tag(): user.code_operators_assignment
tag(): user.code_operators_bitwise
tag(): user.code_operators_math

settings():
    user.code_private_function_formatter = "SNAKE_CASE"
    user.code_protected_function_formatter = "SNAKE_CASE"
    user.code_public_function_formatter = "SNAKE_CASE"
    user.code_private_variable_formatter = "SNAKE_CASE"
    user.code_protected_variable_formatter = "SNAKE_CASE"
    user.code_public_variable_formatter = "SNAKE_CASE"

# rust-specific grammars

## for unsafe rust
state unsafe: "unsafe "
(state) unsafe block: user.code_state_unsafe()

## rust centric struct and enum definitions
state (struct | structure) [<user.text>]:
    insert("struct ")
    insert(user.formatted_text(text or "", "PUBLIC_CAMEL_CASE"))

state enum [<user.text>]:
    insert("enum ")
    insert(user.formatted_text(text or "", "PUBLIC_CAMEL_CASE"))

toggle use: user.code_toggle_libraries()

# TODO: It would be nice if there was a way to not let text match on certain words, because this conflict with
# the let type command below

state let <user.text>:
    insert("let ")
    insert(user.formatted_text(text or "", "SNAKE_CASE"))
    insert(" = ")

state let mute <user.text>:
    insert("let mut ")
    insert(user.formatted_text(text or "", "SNAKE_CASE"))

state let type <user.code_type> <user.text>:
    insert("let ")
    insert(user.formatted_text(text or "", "SNAKE_CASE"))
    insert(": ")
    insert(user.code_type())
    insert(" = ")

## Simple aliases
[state] (borrowed | borrow): "&"
[state] (borrowed | borrow) (mutable | mute): "&mut "
state (a sink | async | asynchronous): "async "
state (pub | public): "pub "
state (pub | public) crate: "pub(crate) "
state (dyn | dynamic): "dyn "
state type: "type "
state (const | constant): "const "
state (funk | func | function): "fn "
state (imp | implements): "impl "
state let mute: "let mut "
state let: "let "
state (mute | mutable): "mut "
state (mod | module): "mod "
state ref (mute | mutable): "ref mut "
state ref: "ref "
state trait: "trait "
state match: user.code_state_switch()
state (some | sum): "Some"
state static: "static "
state move: "move "
self taught: "self."
state a sync block: user.insert_between("async {", "}")
state match a sync block: user.insert_between("match async {", "}.await {}")
state await: ".await"

state init defaults: "..Default::default()"

use <user.code_libraries>:
    user.code_insert_library(code_libraries, "")
    key(; enter)
use {user.rust_crates} prelude:
    insert("use {rust_crates}::prelude::*;")
    key(enter)
use crate: user.insert_between("use crate::", ";")

## specialist flow control
state if let some: user.code_insert_if_let_some()
state if let (ok | okay): user.code_insert_if_let_okay()
state if let error: user.code_insert_if_let_error()

## rust centric synonyms
is some: user.code_insert_is_not_null()

## for implementing
implement (struct | structure): user.code_state_implements()

## for annotating function parameters
is implemented trait {user.code_trait}: user.code_insert_trait_annotation(code_trait)
is implemented trait: ": impl "
returns implemented trait {user.code_trait}: user.code_insert_return_trait(code_trait)
returns implemented trait: " -> impl "

## for generic reference of traits
trait {user.code_trait}: insert("{code_trait}")
implemented trait {user.code_trait}: insert("impl {code_trait}")
dynamic trait {user.code_trait}: insert("dyn {code_trait}")

## for generic reference of macro
macro {user.code_macros}: user.code_insert_macro(code_macros, "")
macro wrap {user.code_macros}:
    user.code_insert_macro(code_macros, edit.selected_text())

## rust specific document comments
documentation: insert("/// ")
inner documentation: user.code_comment_documentation_inner()
inner block documentation: user.code_comment_documentation_block_inner()

state returns: " -> "
# TODO: They should use a list
state empty ok: "Ok(())"
state empty error: "Err(())"
state empty some: "Some(())"
state doc [comment]: "///"
state empty result: "Result::Ok(())"
state arm: "=> "
state arm open: "=> {"
state arm block: "=> {}"
state right [inclusive] range: "..="
state left [inclusive] range: "=.."
state range: ".."
state at range: "@ .."
[state] turbo fish: "::<>"
turbo crate: "crate::"
turbo stood: "std::"
[state] turbo <user.word>: "{word}::"
state at <user.text>: "{text} @ "
state label range: user.insert_between("", "@ ..")
state new vec: "Vec::new()"
state new box: "Box::new()"
state use: user.code_import()
#state use: "use "
state use block: user.insert_between("use {", "};")
state use {user.rust_crates}: user.insert_between("use {rust_crates}::", ";")
state tokyo main: "#[tokio::main]"
state A sink: "async "
state pub: "pub "
state mod: "mod "
state static ref: "static ref "

# TODO: Make all derivable trait values something we can say and have automatically added
state derive: user.insert_between("#[derive(", ")]")
state derive debug: "#[derive(Debug)]"
state derive clone: "#[derive(Clone)]"
state derive copy: "#[derive(Copy)]"
state derive default: "#[derive(Default)]"
state derive display: "#[derive(Display)]"
state derive error: "#[derive(Error)]"
state default: "#[default]"
funk {user.formatted_functions}:
    insert(formatted_functions)
    user.insert_between('("', '");')
state A sink trait: "#[async_trait]"

state used: "#[used]"
state test: "#[test]"
state ignore: "#[ignore]"
state ignored test: "#[test]\n#[ignore]"
state config test: "#[cfg(test)]"
state config any: user.insert_between("#[cfg(any(", "))]")
state config X sixty four: '#[cfg(target_arch = "x86_64")]'
state config X thirty two: '#[cfg(target_arch = "x86")]'
state config arm: '#[cfg(target_arch = "arm")]'
state config arm sixty four: '#[cfg(target_arch = "aarch64")]'
# TODO: It would be nice to automatically be able to specify multiple
# architecture's and wrap it inside of any()
# TODO: automatically create test module in functions, add things like expect panic
state (rep | represent) C: "#[repr(C)]"

state global warn unused variables: "#![warn(unused_variables)]"
state global warn unused imports: "#![warn(unused_imports)]"
state global warn unused results: "#![warn(unused_results)]"
state global warn unused mut: "#![warn(unused_mut)]"
state global warn dead code: "#![warn(dead_code)]"

state warn unused variables: "#[warn(unused_variables)]"
state warn unused imports: "#[warn(unused_imports)]"
state warn unused results: "#[warn(unused_results)]"
state warn unused mut: "#[warn(unused_mut)]"
state warn dead code: "#[warn(dead_code)]"

state global allow unused variables: "#![allow(unused_variables)]"
state global allow unused imports: "#![allow(unused_imports)]"
state global allow unused results: "#![allow(unused_results)]"
state global allow unused mut: "#![allow(unused_mut)]"
state global allow non camel [case] [types]: "#![allow(non_camel_case_types)]"
state global allow dead code: "#![allow(dead_code)]"
state global allow unreachable code: "#![allow(unreachable_code)]"

state allow unused variables: "#[allow(unused_variables)]"
state allow unused imports: "#[allow(unused_imports)]"
state allow unused results: "#[allow(unused_results)]"
state allow unused mut: "#[allow(unused_mut)]"
state allow non camel [case] [types]: "#[allow(non_camel_case_types)]"
state allow dead code: "#[allow(dead_code)]"
state allow unreachable code: "#[allow(unreachable_code)]"

[state] returns [result] box error: "-> Result<(), Box<dyn Error>>"
state result box error: "Result<(), Box<dyn Error>>"

state result of <user.code_type> and <user.code_type>:
    "Result<{code_type}, Box<dyn Error>>"

state form {user.closed_format_strings}: insert("{closed_format_strings}")
state form inner {user.inner_format_strings}: insert(":{inner_format_strings}")

state [{user.code_type_modifier}] sliced <user.code_type>:
    insert(code_type_modifier or "")
    insert("[{code_type}]")

state [{user.code_type_modifier}] <number> element <user.code_type> array:
    insert(code_type_modifier or "")
    insert("[{code_type}; {number}]")

state [{user.code_type_modifier}] <user.code_type> array:
    insert(code_type_modifier or "")
    user.insert_between("[{code_type}; ", "]")

state zero init <number> elements: insert("[0; {number}]")

state as <user.code_type>: "as {code_type}"

state new {user.rust_allocatable_types}: insert("{rust_allocatable_types}::new()")

state (stood | standard) {user.rust_std_modules}: insert("std::{rust_std_modules}::")

state generics: user.insert_between("<", ">")

state (stood | standard) {user.rust_std_modules} <user.text>:
    insert("std::{rust_std_modules}::")
    insert(user.formatted_text(text or "", "PUBLIC_CAMEL_CASE"))

state component <user.text>:
    insert("#[component]\nfn ")
    insert(user.formatted_text(text or "", "PUBLIC_CAMEL_CASE"))
    user.insert_between("() -> impl IntoView {", "}")

state view:
    user.insert_between("view! {", "}")

state (oto | auto): insert("auto") 

view divide:
    user.insert_between("<div>", "</div>")

view span:
    user.insert_between("<span>", "</span>")

view header one:
    user.insert_between("<h1>", "</h1>")

view single <user.text>:
    insert("<")
    insert(user.formatted_text(text or "", "PUBLIC_CAMEL_CASE"))
    insert(" />")

view <user.text>:
    tag = user.formatted_text(text or "", "PUBLIC_CAMEL_CASE")
    open = "<{tag}>"
    close = "</{tag}>"
    user.insert_between(open, close)

state collect as <user.code_containing_type> of [<user.code_type>]:
    type = user.code_type or ""
    insert("collect::{code_containing_type}<{type}>()")

terminate: 
    edit.line_end()
    key(';')
    edit.line_insert_down()