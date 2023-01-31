# exfuz

exfuz is able to fuzzy search for excel by using fuzzy finder tools such as fzf, peco

## Features

- fuzzy search is possible for excel workbook, sheet, cells
    - note: In the current version, exfuz cannot be used if the Ruby environment is Windows.
- can jump to positions selected lines by fuzzy finder tools
    - note: In the current version, the jump function is only available in wsl.

## Demo
![demo](https://user-images.githubusercontent.com/85052152/213947172-8917d9a8-1f88-42a2-9fc1-53c8de25e309.gif)

## Installation

```sh
gem install exfuz
```

Install the fuzzy finder tool.[^1]
[^1]:One of the following fuzzy finder tools must be installed in advance.</br>
・[fzf](https://github.com/junegunn/fzf)</br>
・[peco](https://github.com/peco/peco)</br>
・[percol](https://github.com/mooz/percol)</br>
・[skim](https://github.com/lotabout/skim)

## Usage

```sh
exfuz start
```

Sources to be searched are xlsx files under the current directory hierarchy.

### Query
It is possible to enter a query on the initial screen. Only cells matching the query will be subject to fuzzy search.</br>
For example, in the figure below, enter the regular expression `test.*data` in the query area.
![image](https://user-images.githubusercontent.com/85052152/215886143-6c2750a9-72d9-4b3d-ad86-334569f88642.png)

### Item Format
The format of the items read by fuzzy finder tool is as follows.</br>

```sh
LineNumber:FileName:SheetName:CellAddress:CellValue
```

`LineNumber` is the order of the data passed to the standard input. Also, the delimiter character for each content is`:`.


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
3. Default settings

| Option                    | Values / Default Value                                                            | Description                                                                  |
|---------------------------|-----------------------------------------------------------------------------------|------------------------------------------------------------------------------|
| book_name_path_type       | [”relative”, “absolute”] </br> Default Value: "relative"                          | Format to display book name. </br> relative path or absolute path.           |
| cell_position_format      | [”index”, “address”] </br> Default Value: "address"                               | Format to display cell position </br> ex) index: $3$4, address: $C$4         |
| line_sep                  | Arbitary character </br> Default Value: ":"                                       | Delimiter char </br> ex) book1.xlsx:sheet1:$A$1:value if delimiter char is : |
| split_new_line            | [true, false] </br> Default Value: false                                          | Whether to escape line breaks in cells                                       |
| fuzzy_finder_command_type | ["fzf", "peco", "percol", "sk"][^2]  </br> Default Value: "fzf" | Which fuzzy finder tool to use                                               |
[^2]: Value to fuzzy finder tool is as followeds.   </br>
・"fzf": fzf</br>
・"peco": peco</br>
・"percol": percol</br>
・"sk": skim

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT)
