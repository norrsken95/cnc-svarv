$eu8 = New-Object System.Text.UTF8Encoding($false)
$ws = "C:\Users\ihorp\Desktop\CNC Svarv"
$files = @("200-05","200-06","200-07","200-08","200-09","200-10","200-11")

foreach ($f in $files) {
    $p = "$ws\$f\$f.html"
    $h = [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)

    $sheet = "  <div class=`"sheet`">`n`n  <table class=`"top`">`n    <tr>`n      <td class=`"logo`" rowspan=`"2`" colspan=`"2`"><img src=`"../YA_LOGO.png`" alt=`"YA`"></td>`n      <td class=`"title`" rowspan=`"2`" colspan=`"2`">`n`t`t<img src=`"../Mastercam-Logo.jpg`" alt=`"Mastercam`">`n`t`t</td>`n      <td class=`"lbl`" colspan=`"2`">ARBETSSTYCKE STORLEK</td>`n      <td class=`"val`" colspan=`"2`"></td>`n    </tr>`n    <tr>`n      <td class=`"lbl`" colspan=`"2`">OPERATION NR</td>`n      <td class=`"val`" colspan=`"2`">OP10 (program $f.NC)</td>`n    </tr>`n    <tr>`n      <td class=`"lbl`">MASKIN</td>`n      <td class=`"val`" colspan=`"3`">HAAS ST-10 Svarv</td>`n      <td class=`"lbl`">MATERIAL</td>`n      <td class=`"val`" colspan=`"1`">SS 1914 (11SMnPb30+C)</td>`n      <td class=`"lbl`">PROGRAMMERARE</td>`n      <td class=`"val`">Ihor Posunko</td>`n    </tr>`n    <tr>`n      <td class=`"lbl`">PROJEKTNAMN</td>`n      <td class=`"val`" colspan=`"3`"></td>`n      <td class=`"lbl`">RITNINGSNR</td>`n      <td class=`"val`">$f</td>`n      <td class=`"lbl`">SKIFT / OPERAT" + [char]0xD6 + "R</td>`n      <td class=`"val`"></td>`n    </tr>`n    <tr><td class=`"band`" colspan=`"8`"></td></tr>`n  </table>`n`n  <table class=`"ops`">`n    <thead>`n      <tr>`n        <th rowspan=`"2`">Op nr</th>`n        <th rowspan=`"2`">Operation</th>`n        <th rowspan=`"2`">Verktygs-<br>specifikation</th>`n        <th rowspan=`"2`">Vkt<br>nr</th>`n        <th colspan=`"3`">Verktygsgeometri</th>`n        <th rowspan=`"2`">H" + [char]0xE5 + "llare</th>`n        <th rowspan=`"2`">Sk" + [char]0xE4 + "rhastighet<br>vc (m/min)</th>`n        <th rowspan=`"2`">Matning<br>fn (mm/varv)</th>`n        <th rowspan=`"2`">Sk" + [char]0xE4 + "rdjup<br>ap (mm)</th>`n        <th rowspan=`"2`">Tid<br>h:mm:ss</th>`n        <th rowspan=`"2`">Anm" + [char]0xE4 + "rkningar</th>`n      </tr>`n      <tr>`n        <th>CR</th>`n        <th>Bredd</th>`n        <th>OH</th>`n      </tr>`n    </thead>`n    <tbody>`n      <tr>`n        <td>1</td>`n        <td class=`"l`"></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td class=`"rem`"></td>`n      </tr>`n      <tr>`n        <td>2</td>`n        <td class=`"l`"></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td class=`"rem`"></td>`n      </tr>`n      <tr>`n        <td>3</td>`n        <td class=`"l`"></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td></td>`n        <td class=`"rem`"></td>`n      </tr>`n    </tbody>`n  </table>`n`n  <table class=`"total`">`n    <tr>`n      <td class=`"gap`" style=`"width:62%`"></td>`n      <td class=`"tl`" style=`"width:24%`">Total tid h : min : sek</td>`n      <td class=`"tv`"></td>`n    </tr>`n  </table>`n`n  <table class=`"note`">`n    <tr>`n      <td class=`"nh`">Notering:`n      </td>`n    </tr>`n  </table>`n`n  <table class=`"sign`">`n    <tr><th>UPPR" + [char]0xC4 + "TTAD AV</th><th>GODK" + [char]0xC4 + "ND AV</th></tr>`n    <tr><td></td><td></td></tr>`n  </table>`n</div>`n"

    # Find insertion point: end of layout div before code-row
    # Pattern varies slightly by file - find </div> just before <div class="code-row">
    $codeRowIdx = $h.IndexOf('<div class="code-row">')
    if ($codeRowIdx -lt 0) {
        Write-Host "ERROR: code-row not found in $f"
        continue
    }
    # Find the last </div> before code-row (with leading whitespace)
    $beforeCodeRow = $h.Substring(0, $codeRowIdx)
    $lastDivClose = $beforeCodeRow.LastIndexOf("</div>")
    if ($lastDivClose -lt 0) {
        Write-Host "ERROR: closing </div> not found before code-row in $f"
        continue
    }
    $afterClose = $lastDivClose + "</div>".Length
    # Insert sheet between the </div> and whatever follows (leading newlines + code-row)
    $h = $h.Substring(0, $afterClose) + "`n" + $sheet + "  " + $h.Substring($codeRowIdx)
    [System.IO.File]::WriteAllText($p, $h, $eu8)
    Write-Host "Done: $f"
}
Write-Host "All done."
