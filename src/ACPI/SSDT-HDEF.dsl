// by @itsjustinspier

DefinitionBlock ("SSDT-HDEF.aml", "SSDT", 2, "HACK", "HDEF", 0x00000000)
{
    Method (_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) {
            Return (Buffer () { 0x03 })
        }

        Return (Package ()
        {
            "layout-id",
            Buffer () { 0x07, 0x00, 0x00, 0x00 },
            "alc-layout-id",
            Buffer () { 0x14, 0x00, 0x00, 0x00 },
            "hda-gfx",
            Buffer () { "onboard-1" },
            "PinConfigurations",
            Buffer () { },
        })
    }
}
//EOF
