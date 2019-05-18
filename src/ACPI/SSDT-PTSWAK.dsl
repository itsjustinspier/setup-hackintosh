// by @itsjustinspier

DefinitionBlock("SSDT-PTSWAK.aml", "SSDT", 2, "HACK", "PTSWAK", 0x00000000)
{
    External (RMCF.RMON, MethodObj)
    External (RMCF.RMOF, MethodObj)
    External (RMCF.DPTS, IntObj)
    External (RMCF.SHUT, IntObj)
    External (RMCF.XPEE, IntObj)
    External (RMCF.SSTF, IntObj)
    External (ZPTS, MethodObj)
    External (ZWAK, MethodObj)
    External (_SB.PCI0.XHC.PMEE, FieldUnitObj)
    External (_SI._SST, MethodObj)

    // In DSDT, native _PTS and _WAK are renamed ZPTS/ZWAK
    // As a result, calls to these methods land here.
    Method (_PTS, 1)
    {
        if (5 == Arg0)
        {
            // Shutdown fix, if enabled
            If (CondRefOf (\RMCF.SHUT)) {
                If (\RMCF.SHUT) {
                    Return
                }
            }
        }

        // Enable discrete graphics
        If (CondRefOf (\RMCF.RMON)) {
            \RMCF.RMON ()
        }

        // Call into original _PTS method
        If (5 != Arg0) {
            ZPTS (Arg0)
        }

        If (5 == Arg0)
        {
            // XHC.PMEE fix, if enabled
            If (CondRefOf(\RMCF.XPEE)) {
                If (\RMCF.XPEE && CondRefOf(\_SB.PCI0.XHC.PMEE)) {
                    \_SB.PCI0.XHC.PMEE = 0
                }
            }
        }
    }

    Method (_WAK, 1)
    {
        // Take care of bug regarding Arg0 in certain versions of OS X...
        // (starting at 10.8.5, confirmed fixed 10.10.2)
        If (Arg0 < 1 || Arg0 > 5) { Arg0 = 3 }

        // Call into original _WAK method
        Local0 = ZWAK (Arg0)

        // Disable discrete graphics
        If (CondRefOf (\RMCF.RMOF)) {
            \RMCF.RMOF ()
        }

        If (CondRefOf (\RMCF.SSTF))
        {
            If (\RMCF.SSTF)
            {
                // Call _SI._SST to indicate system "working"
                // For more info, read ACPI specification
                If (3 == Arg0 && CondRefOf (\_SI._SST)) {
                    \_SI._SST (1)
                }
            }
        }

        // Return value from original _WAK
        Return (Local0)
    }
}
//EOF
