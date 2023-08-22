# Simple web fileserver script - modified for binary file support
# Must be executed as admin

# Config
$lport = 80
$execdir = Get-Location

$httpsrvlsnr = New-Object System.Net.HttpListener;
$httpsrvlsnr.Prefixes.Add("http://+:$lport/");
$httpsrvlsnr.Start();
$webroot = New-PSDrive -Name webroot -PSProvider FileSystem -Root $execdir
[byte[]]$buffer = $null

while ($httpsrvlsnr.IsListening)
{
    try
    {
        $context = $httpsrvlsnr.GetContext();
        
        if ($context.Request.RawUrl -eq "/")
        {
            $buffer = [System.Text.Encoding]::UTF8.GetBytes("<html><pre>$(Get-ChildItem -Path $execdir -Force | Out-String)</pre></html>");
            $context.Response.ContentLength64 = $buffer.Length;
            $context.Response.OutputStream.WriteAsync($buffer, 0, $buffer.Length)
        }
        elseif ($context.Request.RawUrl -eq "/stop")
        {
            $httpsrvlsnr.Stop();
            Remove-PSDrive -Name webroot -PSProvider FileSystem;
        }
        elseif ($context.Request.RawUrl -match "\/[A-Za-z0-9-\s.)(\[\]]")
        {
            if ([System.IO.File]::Exists((Join-Path -Path $execdir -ChildPath $context.Request.RawUrl.Trim("/\"))))
            {
                $buffer = [System.IO.File]::ReadAllBytes((Join-Path -Path $execdir -ChildPath $context.Request.RawUrl.Trim("/\")));
                $context.Response.ContentLength64 = $buffer.Length;
                $context.Response.OutputStream.WriteAsync($buffer, 0, $buffer.Length)
            } 
        }

    }
    catch [System.Net.HttpListenerException]
    {
        Write-Host ($_);
    }
}
