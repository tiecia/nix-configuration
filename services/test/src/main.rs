use std::process::Command;
use std::thread;

fn main() {
    println!("Hello, world!");

    Command::new("pwd").status().expect("Unable to run command");
    Command::new("ls").status().expect("Unable to run command");

    thread::park();
}
