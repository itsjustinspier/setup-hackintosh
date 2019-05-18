// by @itsjustinspier

DefinitionBlock ("SSDT-ETC.aml", "SSDT", 2, "HACK", "ETC", 0x00000000)
{
    External (RMCF.RMOF, MethodObj)
    External (RMCF.PGOF, MethodObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.XREG, MethodObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {
        OperationRegion (RME3, EmbeddedControl, 0x00, 0xFF)

        Method (_REG, 2)
        {
            XREG (Arg0, Arg1)

            If (3 == Arg0 && 1 == Arg1)
            {
                // Turn dedicated Nvidia fan off
                If (CondRefOf (\RMCF.PGOF)) {
                    \RMCF.PGOF (1)
                }
            }
        }
    }

    // Disable Nvidia card
    Device (RMD1)
    {
        Name (_HID, "RMD10000")

        Method (_INI)
        {
            If (CondRefOf (\RMCF.RMOF)) {
                \RMCF.RMOF ()
            }
        }
    }

    // Add SMBUS device
    Device (_SB.PCI0.SBUS.BUS0)
    {
        Name (_CID, "smbus")
        Name (_ADR, Zero)

        Device (DVL0)
        {
            Name (_ADR, 0x57)
            Name (_CID, "diagsvault")

            Method (_DSM, 4)
            {
                If (!Arg2)
                {
                    Return (Buffer () { 0x03 } )
                }

                Return (Package () { "address", 0x57 })
            }
        }
    }

    // macOS expect PMCR for PPMC to load correctly
    Device (_SB.PCI0.PMCR)
    {
        Name (_ADR, 0x001F0002)
    }

    // Inject Fake EC device
    Device (_SB.EC)
    {
        Name (_HID, "EC000000")
    }

    Device (_SB.USBX)
    {
        Name (_ADR, 0)

        Method (_DSM, 4)
        {
            If (!Arg2) { Return (Buffer () { 0x03 } ) }

            Return (Package ()
            {
                "kUSBSleepPortCurrentLimit",
                2100,
                "kUSBSleepPowerSupply",
                2600,
                "kUSBWakePortCurrentLimit",
                2100,
                "kUSBWakePowerSupply",
                3200,
            })
        }
    }

    // All _OSI calls in DSDT are routed to XOSI
    // As written, this XOSI simulates "Windows 2015" (which is Windows 10)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    // Also, it should return true for all previous versions of Windows.
    Method (XOSI, 1)
    {
        // Simulation targets
        // @see https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi
        Local0 = Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP2",     // Windows XP SP2
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            "Windows 2006.1",       // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Server 2012
            "Windows 2013",         // Windows 8.1/Windows Server 2012 R2
            "Windows 2015",         // Windows 10/Windows Server TP
            "Windows 2016",         // Windows 10, version 1607
            "Windows 2017",         // Windows 10, version 1703
            "Windows 2017.2",       // Windows 10, version 1709
            "Windows 2018",         // Windows 10, version 1803
        }

        Return (Ones != Match (Local0, MEQ, Arg0, MTR, 0, 0))
    }

    // In DSDT, native GPRW is renamed to XPRW with Clover binpatch.
    // As a result, calls to GPRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    Method(GPRW, 2, NotSerialized)
    {
        If (0x6D == Arg0) { Return (Package() { 0x6D, 0, }) }
        If (0x0D == Arg0) { Return (Package() { 0x0D, 0, }) }

        External (\XPRW, MethodObj)
        Return (XPRW (Arg0, Arg1))
    }

    Method (_SB.PCI0.XHC._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Local0 = Package()
        {
            "RM,pr2-force",
            Buffer() { 0, 0, 0, 0 },
            "subsystem-id",
            Buffer() { 0x2F, 0xA1, 0x00, 0x00 },
            "subsystem-vendor-id",
            Buffer() { 0x86, 0x80, 0x00, 0x00 },
            "AAPL,current-available",
            Buffer() { 0x34, 0x08, 0, 0 },
            "AAPL,current-extra",
            Buffer() { 0x98, 0x08, 0, 0, },
            "AAPL,current-extra-in-sleep",
            Buffer() { 0x40, 0x06, 0, 0, },
            "AAPL,max-port-current-in-sleep",
            Buffer() { 0x34, 0x08, 0, 0 },
        }

        // force USB2 on XHC if EHCI is disabled
        If (CondRefOf (\_SB.PCI0.RMD2) || CondRefOf (\_SB.PCI0.RMD3) || CondRefOf (\_SB.PCI0.RMD4)) {
            CreateDWordField (DerefOf (Local0[1]), 0, PR2F)
            PR2F = 0x3FFFF
        }

        Return (Local0)
    }
}
//EOF
