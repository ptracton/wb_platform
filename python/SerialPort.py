#! /usr/bin/env python3

'''
This is our Serial Port class.  It inherits from PySerial.  We extend it for
our needs as a packet communication system.
'''
import array
import logging
import serial
import serial.tools.list_ports

import Packet
from constants import *


class SerialPort(serial.Serial):
    """
    This is the SerialPort class.  It inherits from pyserial,
    http://pyserial.sourceforge.net/.  It defaults to 115200 baud rate
    8 data bits, no parity and 1 stop bit.
    """

    def __init__(self, port="/dev/ttyUSB0", baud_rate="115200", bits=8,
                 parity="None", stop_bits=1):
        """
        SerialPort constructor.  This will open the serial port specified
        or terminate the program if it can not open it.
        """
        super(SerialPort, self).__init__(timeout=0.25)

        try:
            com_port_list = list(serial.tools.list_ports.comports())
            self.ports = [x[0] for x in com_port_list]
        except (NameError, TypeError):
            self.ports = ["/dev/ttyUSB0"]

        print("List of Ports {}".format(self.ports))

        self.baudrate = baud_rate

        if bits == 8:
            # self.setByteSize(serial.EIGHTBITS)
            self.bytesize = serial.EIGHTBITS
        elif bits == 7:
            # self.setByteSize(serial.SEVENBITS)
            self.bytesize = serial.SEVENBITS
        elif bits == 6:
            # self.setByteSize(serial.SIXBITS)
            self.bytesize = serial.SIXBITS
        elif bits == 5:
            # self.setByteSize(serial.FIVEBITS)
            self.bytesize = serial.FIVEBITS

        if parity == "None":
            # self.setParity(serial.PARITY_NONE)
            self.parity = serial.PARITY_NONE
        elif parity == "Even":
            # self.setParity(serial.PARITY_EVEN)
            self.parity = serial.PARITY_EVEN
        elif parity == "Odd":
            # self.setParity(serial.PARITY_ODD)
            self.parity = serial.PARITY_ODD
        elif parity == "Mark":
            # self.setParity(serial.PARITY_MARK)
            self.parity = serial.PARITY_MARK
        elif parity == "Space":
            # self.setParity(serial.PARITY_SPACE)
            self.parity = serial.PARITY_SPACE
        if stop_bits == 1:
            # self.setStopbits(serial.STOPBITS_ONE)
            self.stopbits - serial.STOPBITS_ONE
        elif stop_bits == 2:
            # self.setStopbits(serial.STOPBITS_TWO)
            self.stopbits = serial.STOPBITS_TWO
        return

    def connect(self):
        """
        attempt to open the serial port
        """
        try:
            self.open()
            logging.info("%s: Open Serial Port successful" %
                         (__name__))
        except OSError:
            logging.error("%s: Failed to open Serial Port" %
                          (__name__, ))
        return

    def get_list_of_ports(self):
        """
        Returns a list of serial ports on this computer
        """
        return self.ports

    def transmit_binary(self, data):
        """
        Send binary data and NOT ASCII data.  We expect a list of numbers to be
        transmitted.
        """
        #
        # http://stackoverflow.com/questions/472977/binary-data-with-pyserialpython-serial-port
        #
        #print("Trans Binary: ", data)
        transmit = array.array('B', data).tostring()
        #print("Transmit", transmit)
        self.write(transmit)

        return

    def DAQ_Write(self, file=None, data=None):
        if file is None or data is None:
            return

        print("DAQ_WRITE: File={:08x} Data={:08x}".format(file, data))
        command = COMMAND_DAQ_WRITE
        pkt = Packet.Packet(command=command, write=False,
                            address=file, data=data)
        pkt.to_bytes()
        transmit = array.array('B', pkt.bytesList).tostring()
        self.write(transmit)

    def CPU_Write(self, address=None, data=None):

        if address is None or data is None:
            return

        command = COMMAND_CPU_WRITE
        pkt = Packet.Packet(command=command, write=False,
                            address=address, data=data)
        pkt.to_bytes()
        transmit = array.array('B', pkt.bytesList).tostring()
        self.write(transmit)
        print("CPU_WRITE: Address={:08x} Data={:08x}".format(address, data))
        return

    def CPU_Read(self, address=None):

        if address is None:
            return

        command = COMMAND_CPU_READ
        pkt = Packet.Packet(command=command, write=False,
                            address=address, data=[])
        pkt.to_bytes()
        transmit = array.array('B', pkt.bytesList).tostring()
        self.write(transmit)
        response = self.read(4)
        uint32 = int.from_bytes(response, "little")
        print("CPU_READ: Address={:08x} Data={:08x}".format(address, uint32))
        return uint32
