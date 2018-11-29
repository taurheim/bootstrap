$code=@'
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.IO;
    using System.Runtime.InteropServices;

    public static class  FontUtil{
        [DllImport("gdi32.dll")]
            public static extern int AddFontResource(string lpFilename);
    }
'@
Add-Type $code
[fontutil]::AddFontResource("$($args[0])")