#! /usr/bin/env python3

from constants import *


class Packet:
    """
    """

    def __init__(self, command=None, write=None, address=None, data=None):
        """
        """
        self.packetIsValid = False
        self.dataIsList = (type(data) == type([]))
        self.dataIsInteger = (type(data) == type(0))
        if self.dataIsList:
            self.length = len(data)
            if (self.length > 255):
                return None
        elif self.dataIsInteger:
            self.length = 1
        else:
            return None

        self.packetIsValid = True
        self.data = data
        self.command = command
        self.write = write
        self.address = address
        self.bytesList = []
        if data is None:
            self.data = []
        else:
            self.data = data  # should be a list of bytes

        return

    def __str__(self):
        str1 = "Packet Bytes\n"
        str2 = " ".join(hex(e) for e in self.bytesList)
        return str1 + str2 + "\n"

    def word_to_bytes(self, word=None):
        """
        Convert a uint32_t to a list of uint8_t
        """
        if word is None or self.packetIsValid is False:
            return [0, 0, 0, 0]
        myList = []
        byte = word & 0x000000FF
        myList.append(byte)
        byte = (word & 0x0000FF00) >> 8
        myList.append(byte)
        byte = (word & 0x00FF0000) >> 16
        myList.append(byte)
        byte = (word & 0xFF000000) >> 24
        myList.append(byte)
        return myList

    def to_bytes(self):
        """
        Convert the fields of the class to a list of bytes to transmit
        """
        self.bytesList.append(0xCA)                 # Preamble
        self.bytesList.append(0xF0 + self.command)  # Command
        # length in WORDS (32 bit values)
        self.bytesList.append(self.length)

        # DAQ address is actually 1 byte of file number
        if self.command == COMMAND_DAQ_WRITE or self.command == COMMAND_DAQ_READ:
            self.bytesList.append(self.address)  # File Number
        else:
            self.bytesList.extend(self.word_to_bytes(self.address))  # Address
        if self.dataIsList:
            for x in self.data:
                self.bytesList.extend(self.word_to_bytes(x))
        else:
            self.bytesList.extend(self.word_to_bytes(self.data))  # data

        #print("to_bytes {}".format(self.bytesList))


if __name__ == "__main__":
    p = Packet(command=COMMAND_CPU_WRITE, address=GPIO_R_OUT, data=0x0000FFFF)
    p.to_bytes()
    print(str(p))
    p = Packet(command=COMMAND_CPU_READ,
               address=RAM1_BASE_ADDRESS, data=[1, 2, 3])
    p.to_bytes()
    print(str(p))
