// by @itsjustinspier

DefinitionBlock ("SSDT-RMCF.aml", "SSDT", 2, "HACK", "RMCF", 0x00000000)
{
    External (_SB.PCI0.PEG0.PEGP, DeviceObj)
    External (_SB.PCI0.PEG0.PEGP._OFF, MethodObj)
    External (_SB.PCI0.PEG0.PEGP._ON, MethodObj)
    External (_SB.PCI0.PGOF, MethodObj)

    Device (RMCF)
    {
        Name (_ADR, 0)

        Method (RMOF) {
            If (CondRefOf (\_SB.PCI0.PEG0.PEGP._OFF)) {
                \_SB.PCI0.PEG0.PEGP._OFF ()
            }
        }

        Method (RMON) {
            If (CondRefOf (\_SB.PCI0.PEG0.PEGP._ON)) {
                \_SB.PCI0.PEG0.PEGP._ON ()
            }
        }

        Method (PGOF, 1) {
            If (CondRefOf (\_SB.PCI0.PGOF)) {
                \_SB.PCI0.PGOF (Arg0)
            }
        }
    }
}
//EOF
