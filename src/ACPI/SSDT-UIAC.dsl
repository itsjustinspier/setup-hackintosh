// by @itsjustinspier

DefinitionBlock ("SSDT-UIAC.aml", "SSDT", 2, "HACK", "UIAC", 0x00000000)
{
    Device (UIAC)
    {
        Name (_HID, "UIA00000")

        Name (RMCF, Package()
        {
            "8086_a12f", Package()
            {
                "port-count",
                Buffer() { 0x12, 0x00, 0x00, 0x00 },
                "ports", Package()
                {
                    "HS01", Package ()
                    {
                        "UsbConnector", 0x03,
                        "port", Buffer () { 0x01, 0x00, 0x00, 0x00 },
                    },
                    "HS02", Package ()
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer () { 0x02, 0x00, 0x00, 0x00 },
                    },
                    "HS03", Package ()
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer () { 0x03, 0x00, 0x00, 0x00 },
                    },
                    "HS04", Package ()
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer () { 0x04, 0x00, 0x00, 0x00 },
                    },
                    "HS06", Package ()
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer () { 0x06, 0x00, 0x00, 0x00 },
                    },
                    "HS07", Package ()
                    {
                        "UsbConnector", 0x00,
                        "port", Buffer () { 0x07, 0x00, 0x00, 0x00 },
                    },
                    "HS08", Package ()
                    {
                        "UsbConnector", 0x00,
                        "port", Buffer () { 0x08, 0x00, 0x00, 0x00 },
                    },
                    "HS09", Package ()
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer () { 0x09, 0x00, 0x00, 0x00 },
                    },
                    "SS01", Package ()
                    {
                        "UsbConnector", 0x03,
                        "port", Buffer () { 0x0B, 0x00, 0x00, 0x00 },
                    },
                    "SS03", Package ()
                    {
                        "UsbConnector", 0x03,
                        "port", Buffer () { 0x0D, 0x00, 0x00, 0x00 },
                    },
                },
            },
        })
    }
}
// EOF
