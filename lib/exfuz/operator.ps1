$excel = New-Object -ComObject Excel.Application

$excel.Visible = $true

$jumpList = ConvertFrom-Json $Input
$books = $jumpList | % { $_.info.book_name } | Select-Object -Unique 

foreach ($jump in $jumpList) {

}


Function Jump($to, $info) {

  $book = $excel.Workbooks.Open($bookPath)
  switch ($to) {
    'book_name' { JumpBook($info.book_name) }
    'sheet_name' { 
        $result = JumpBook($info.book_name) 
        if ($result) {
            JumpSheet($info.sheet_name) 
        }
    }
    'textable' { 
        $result = JumpBook($info.book_name) 
        if ($result) {
            JumpSheet($info.sheet_name) 
            JumpCell($info.textable) 
        }
    }
    Default {}
  }
}

Function isOpenBook($path) {
    $opendPaths = $excel.Workbooks | % {$_.Path()}
    return $openedPaths.Contains($path)
}

Function JumpBook($path) {
  $bookPath = $info.book_name
  if(isOpen($bookPath)) {
    return $false
  }
  return $excel.Workbooks.Open($path)
}