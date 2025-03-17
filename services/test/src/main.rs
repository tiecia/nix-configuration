use std::process::Command;

fn main() {
    println!("Hello, world!");

    Command::new("pwd").status().expect("Unable to run command");
    Command::new("ls").status().expect("Unable to run command");
    Command::new("ags").status().expect("Unable to run command");
}
