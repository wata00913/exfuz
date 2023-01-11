# exfuz

exfuz is able to fuzzy search for excel by using fuzzy finder tools such as fzf, peco

## Features

- fuzzy search is possible for excel workbook, sheet, cells
    - note: In the current version, exfuz cannot be used if the Ruby environment is Windows.
- can jump to positions selected lines by fuzzy finder tools
    - note: In the current version, the jump function is only available in wsl.

## Demo


## Installation

```sh
gem install exfuz
```

## Usage

```sh
exfuz start
```

Sources to be searched are xlsx files under the current directory hierarchy.

## Key binding

| Key         | Description                             |
|-------------|-----------------------------------------|
| CTRL-R      | Launch Fuzzy Finder tool                |
| CTRL-E      | Stop exfuz                              |
| CTRL-H      | Back to previous page of selection list |
| CTRL-L      | Go to next page of selection list       |
| Right Arrow | Move Query cursor to right              |
| Left Arrow  | Move Query cursor to left               |
| BACKSPACE   | Delete one character in Query           |

## Options

Setting file is `.exfuz.json` . 

The priority for reading the configuration is as follows.

1. `./.exfuz.json`
2. `~/.config/exfuz/.exfuz.json`
3. default settings

| option               | Values / Default Value                                 | Description                                                                  |
|----------------------|--------------------------------------------------------|------------------------------------------------------------------------------|
| book_name_path_type  | [”relative”, “absolute”] </br> Default Value: relative | Format to display book name. </br> relative path or absolute path.           |
| cell_position_format | [”index”, “address”] </br> Default Value: address      | Format to display cell position </br> ex) index: $3$4, address: $C$4         |
| line_sep             | Arbitary character                                     | Delimiter char </br> ex) book1.xlsx:sheet1:$A$1:value if delimiter char is : |
| split_new_line       | [true, false] </br> Default Value: false               | Whether to escape line breaks in cells                                       |

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT)
