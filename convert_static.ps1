$path = "C:\Users\ihorp\Desktop\CNC Svarv\Svarvprojekt – CNC avgångsarbete.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$html = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# Extract ITEMS JSON array
$start = $html.IndexOf("const ITEMS = ") + "const ITEMS = ".Length
$end = $html.IndexOf("`n]", $start) + 1
$jsonStr = $html.Substring($start, $end - $start).Trim()
$items = $jsonStr | ConvertFrom-Json
Write-Host "Found $($items.Count) items"

# HTML escape function (matches the JS esc() function)
function Esc([string]$s) {
    return $s.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;')
}

# Generate static cards
$sb = New-Object System.Text.StringBuilder
foreach ($item in $items) {
    $tags = ($item.ops | ForEach-Object { "<span>$(Esc $_)</span>" }) -join ""
    [void]$sb.AppendLine("    <li class=`"card`">")
    [void]$sb.AppendLine("      <div class=`"pic`"><img src=`"$($item.bild)`" alt=`"$(Esc $item.namn), 3D-modell`" loading=`"lazy`"></div>")
    [void]$sb.AppendLine("      <div class=`"info`">")
    [void]$sb.AppendLine("        <div class=`"nr`">$($item.nr)</div>")
    [void]$sb.AppendLine("        <h3><a href=`"$($item.href)`">$(Esc $item.namn)</a></h3>")
    [void]$sb.AppendLine("        <p>$(Esc $item.text)</p>")
    [void]$sb.AppendLine("        <div class=`"tags`">$tags</div>")
    [void]$sb.AppendLine("        <div class=`"go`">Visa projekt <span aria-hidden=`"true`">&#8250;</span></div>")
    [void]$sb.AppendLine("      </div>")
    [void]$sb.AppendLine("    </li>")
}
$cardsHtml = $sb.ToString().TrimEnd()

# Replace the empty grid with static cards
$gridPlaceholder = '<ul class="grid" id="grid"></ul>'
$gridReplacement = "<ul class=`"grid`" id=`"grid`">`n$cardsHtml`n    </ul>"
$html = $html.Replace($gridPlaceholder, $gridReplacement)
Write-Host "Replaced grid with $($items.Count) static cards"

# Replace the count text
$countPlaceholder = '<p class="count" id="count" aria-live="polite"></p>'
$countReplacement = "<p class=`"count`" aria-live=`"polite`">Visar $($items.Count) av $($items.Count) 'ovningar</p>"
$html = $html.Replace($countPlaceholder, $countReplacement)

# Replace the total count
$totalPlaceholder = '<b id="total">0</b>'
$totalReplacement = "<b id=`"total`">$($items.Count)</b>"
$html = $html.Replace($totalPlaceholder, $totalReplacement)

# Remove the entire <script>...</script> block
$scriptStart = $html.IndexOf("<script>")
$scriptEnd = $html.IndexOf("</script>", $scriptStart) + "</script>".Length
if ($scriptStart -ge 0 -and $scriptEnd -gt $scriptStart) {
    $html = $html.Substring(0, $scriptStart) + $html.Substring($scriptEnd)
    Write-Host "Removed script block"
}

# Write the file
[System.IO.File]::WriteAllText($path, $html, $enc)
Write-Host "Done! Static HTML saved to $path"
