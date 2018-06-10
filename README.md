# joplin-note
Simple wrapper script for [Joplin CLI](https://github.com/laurent22/joplin/blob/master/readme/terminal.md), for those that want to speedily make a note from terminal.

## Usage
```
./joplin-note.sh [-h] [-s] [-f] [-b notebook_name] [+<tag>] note_title note description [+<tag>]...
    -h                  This help page
    -s                  Preform sync after your note has been added
    -f                  Silent mode, does not return anything unless some error occur
                        and simply creates a notebook if the one specified does not exist.
    -b <notebook_name>  Specify a notebook to add the note to (default is "unsorted").
                        It will ask you whether you would like to create a new book if it
                        does not already exist.
    +<tag>              Add tags anywhere by starting the tag with a plus sign
```
Silent mode is useful when using the script as a way for other programs to easily send notes to Joplin.


## Tips
Almost mandatory is creating an alias for the script:

Add alias in your ~/.bashrc by inserting the line "n=path-to-scripts/joplin-note.sh"

Or if you are using Fish add a file named n.fish to ~/.config/fish/functions/
with the following lines of code:
```bash
function n
    ~/path-to-script/joplin-note.sh $argv;
end
```


### Examples
```
n RandomThoughts +pets I have had thoughts about getting a cat lately. +cat
```
Adds a note titled "RandomThoughts" saying "I have had thoughts about getting a cat lately.", and adds the two tags "pets" and "cat" to the note.

```
n -s -b Smells_I_Like Flowers Flowers have a wonderful smell.
```
Adds a note to the notebook "Smells_I_Like" with the title "Flowers" saying "Flowers have a wonderful smell." and in the end syncs with the sync method configured in joplin-cli.


#### Further improvements
- Support for quotation marks to allow white spaces in notebook, title and tags
