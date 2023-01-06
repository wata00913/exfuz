param( 
 [Parameter(ValueFromPipeline=$true)][string]$in
)
$excel = New-Object -ComObject Excel.Application

$excel.Visible = $true
Function Jump($to, [ref]$info) {
  switch ($to) {
    'book_name' { $book = JumpBook $info.Value.book_name }
    'sheet_name' { 
        $book = JumpBook $info.Value.book_name 
        if ($book) {
            $sheet = JumpSheet ([ref]$book) $info.Value.sheet_name
        }
    }
    'textable' { 
        $book = JumpBook $info.Value.book_name
        if ($book) {
            $sheet = JumpSheet ([ref]$book) $info.Value.sheet_name 
            $cell = JumpCell ([ref]$sheet) ([ref]$info.Value.textable) 
        }
    }
    Default {}
  }
}

Function IsOpen($path) {
    $openedPaths = @($excel.Workbooks | % {$_.Path})
    if ($null -eq $openedPaths) {
      return $false
    }
    return $openedPaths.Contains($path)
}

Function JumpBook($path) {
  if(IsOpen $path) {
    return $null
  }
  $book = $excel.Workbooks.Open($path)
  return $book
}

Function JumpSheet([ref]$book, $sheetName) {
  $sheet = $book.Value.Worksheets($sheetName)
  $sheet.Activate()
  return $sheet
}

Function JumpCell([ref]$sheet, [ref]$cellPosition) {
  $cell = $sheet.Value.Cells($cellPosition.Value.row, $cellPosition.Value.col)
  $cell.Activate()
  return $cell
}

$targets = ConvertFrom-Json $in
try {
  foreach ($target in $targets) {
    $result = Jump $target.to ([ref]$target.info)
  } 
} finally {
  #$excel.Quit()
}
