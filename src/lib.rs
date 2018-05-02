#![feature(lang_items)]
#![no_std]

extern crate rlibc;

#[no_mangle]
pub extern fn rust_main() {
    let x = ["Hello", "World", "!"];
    let y = x;
}

#[no_mangle]
pub extern fn cstartup() {
    
}

#[no_mangle]
pub extern fn cinit_core() {
    
}

#[no_mangle]
pub extern fn interrupt_handler_fiq() {
    
}

#[no_mangle]
pub extern fn interrupt_handler_irq() {
    
}

#[no_mangle]
pub extern fn interrupt_handler_sync() {
    
}

#[lang = "eh_personality"]
#[no_mangle]
pub extern fn eh_personality() {}

#[lang = "panic_fmt"] 
#[no_mangle] 
pub extern fn panic_fmt() -> ! {loop{}}