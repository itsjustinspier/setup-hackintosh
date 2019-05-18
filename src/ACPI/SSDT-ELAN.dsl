// by @itsjustinspier

DefinitionBlock ("SSDT-ELAN.aml", "SSDT", 2, "HACK", "ELAN", 0x00000000)
{
    External (_SB.PCI0.GPI0, DeviceObj)
    External (_SB.PCI0.I2C1.ETPD, DeviceObj)

    Method (_SB.PCI0.GPI0._STA, 0, NotSerialized)
    {
        Return (0x0F)
    }

    Scope (_SB.PCI0.I2C1.ETPD)
    {
        Name (SBFG, ResourceTemplate ()
        {
            GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                )
                {   // Pin list
                    0x0055
                }
        })
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Return (ConcatenateResTemplate (SBFB, SBFG))
        }
    }
}
// EOF
