

import PyQt5
import PyQt5.QtWidgets
import PyQt5.QtGui
import PyQt5.QtCore

import GPIOUI
import SerialPortUI
import SysconUI
import MemoryTabWidget

from constants import *


class UI_CentralWidget(PyQt5.QtWidgets.QDialog):
    """
    This class holds the GUI elements
    """

    def __init__(self, parent=None):
        super(UI_CentralWidget, self).__init__(parent)

        self.timer_one_second = PyQt5.QtCore.QTimer()
        self.timer_one_second.timeout.connect(self.one_second)
        self.timer_one_second.start(1000)
        self.seconds_count = 0

        topVboxLayout = PyQt5.QtWidgets.QVBoxLayout()
        self.mySerialPort = SerialPortUI.SerialPortUI()
        self.mySerialPort.connectButtonSignal.connect(self.serialPortConnect)

        self.mySyscon = SysconUI.SysconUI()
        self.mySyscon.SysconControlPushButton.clicked.connect(
            self.sysconControlPushButton)

        enableIcon = PyQt5.QtGui.QIcon("green_ball.png")
        disableIcon = PyQt5.QtGui.QIcon("black_ball.png")
        self.GPIO_LEDS = GPIOUI.GPIOUI(
            label="LEDS", enableIcon=enableIcon, disableIcon=disableIcon)

        enableIcon = PyQt5.QtGui.QIcon("upward.png")
        disableIcon = PyQt5.QtGui.QIcon("download.png")
        self.GPIO_SW = GPIOUI.GPIOUI(
            label="Switches", enableIcon=enableIcon, disableIcon=disableIcon)

        self.myTabWidget = PyQt5.QtWidgets.QTabWidget()

        self.myMemoryTabWidget = MemoryTabWidget.MemoryTabWidget()
        self.myMemoryTabWidget.setLayout(self.myMemoryTabWidget.getLayout())
        self.myMemoryTabWidget.clicked.pushButtonSignal.connect(
            self.memoryTabPushButtonClicked)
        self.myMemoryTabWidget.tableWidget.cellChanged.connect(
            self.memoryTabCellChanged)
        self.readingMemoryBoolean = False

        self.myTabWidget.addTab(self.myMemoryTabWidget, "MEMORY")

        topVboxLayout.addLayout(self.mySerialPort.getLayout())
        topVboxLayout.addLayout(self.mySyscon.getLayout())

        topVboxLayout.addLayout(self.GPIO_LEDS.getLayout())
        topVboxLayout.addLayout(self.GPIO_SW.getLayout())
        topVboxLayout.addWidget(self.myTabWidget)

        self.setLayout(topVboxLayout)
        for i in self.GPIO_LEDS.listGPIO:
            # print(type(i.pushButtonSignal))
            # print(i.index)
            i.pushButtonSignal.connect(self.ledsPushButtonClicked)

        return

    def sysconControlPushButton(self):
        control = int(self.mySyscon.SysconControlLineEdit.text(), 16)
        print("sysconControlPushButton Writing {:08x}".format(control))
        self.mySerialPort.serial_port.CPU_Write(SYSCON_R_CONTROL, control)

        control_rd = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_CONTROL)
        print("sysconControlPushButton Readback {}".format(control_rd))
        self.mySyscon.SysconControlLineEdit.setText(
            "{:08x}".format(control_rd))

    def serialPortConnect(self):
        """
        Serial Port Connected
        """
        #print("UI Central Widget serial Port Connect")
        identification = self.mySerialPort.serial_port.CPU_Read(
            SYSCON_R_IDENTIFICATION)
        #print("SYSCON IDENTIFICATION {:08x}".format(identification))
        self.mySyscon.updateIdentification(identification)

        control = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_CONTROL)
        self.mySyscon.SysconControlLineEdit.setText("{:08x}".format(control))

        status = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_STATUS)
        #print("SYSCON STATUS {:08x}".format(status))
        if status & B_SYSCON_STATUS_LOCKED:
            self.mySyscon.SysconStatusLockedCheckBox.setChecked(True)

    def embeddedFileDownload(self, embeddedFile=None):

        if embeddedFile is None:
            return

        address = 0x20 * int(embeddedFile.name) + RAM0_BASE_ADDRESS
        self.mySerialPort.serial_port.CPU_Write(
            address, embeddedFile.start_address)
        self.mySerialPort.serial_port.CPU_Write(
            address + 4, embeddedFile.end_address)
        self.mySerialPort.serial_port.CPU_Write(
            address + 8, embeddedFile.rd_ptr)
        self.mySerialPort.serial_port.CPU_Write(
            address + 12, embeddedFile.wr_ptr)
        self.mySerialPort.serial_port.CPU_Write(
            address + 20, embeddedFile.control)

    def memoryTabCellChanged(self, row=None, column=None):

        if self.readingMemoryBoolean is True or row is None or column is None:
            return

        print("\n")
        print("*"*80)
        print("memoryTabCellChanged {} {}".format(row, column))
        data = int(self.myMemoryTabWidget.tableWidget.item(
            row, column).text(), 16)
        address = int(
            self.myMemoryTabWidget.tableWidget.item(row, 0).text(), 16)
        offset = int(
            self.myMemoryTabWidget.tableWidget.horizontalHeaderItem(column).text(), 16)
        print("memoryTabCellChanged {} {:08x} {} ".format(data, address, offset))
        self.mySerialPort.serial_port.CPU_Write(address, data)

    def memoryTabPushButtonClicked(self, address=None, memoryCount=None):

        if self.mySerialPort.serial_port.is_open is False:
            return

        if address is None or memoryCount is None:
            return
        # Address is a uin32_t, python doesn't really do this, so if the
        # address is negative, 2's compliment it over to a positive value
        # https://stackoverflow.com/questions/20766813/how-to-convert-signed-to-unsigned-integer-in-python
        if address < 0:
            address = address + (1 << 32)

        print("\n")
        print("*"*80)
        print("UI Central Widget memory tab clicked {:08x} {}".format(
            address, memoryCount))
        for memory in range(memoryCount):
            self.readingMemoryBoolean = True
            value = self.mySerialPort.serial_port.CPU_Read(address)
            print("Memory Read {:08x}".format(value))
            self.myMemoryTabWidget.updateMemoryTable(address, value)
            address = address + 4
        self.readingMemoryBoolean = False

    def tabWidgetcurrentChanged(self, index=0):
        if index == 1:
            fileNumber = self.myFileConfigTabWidget.fileNumberComboBox.currentIndex()
            self.fileConfigComboBoxChanged(fileNumber)

    def one_second(self):
        self.seconds_count = self.seconds_count + 1
        #print("One Second {}".format(self.seconds_count))
        return

    def ledsPushButtonClicked(self, index=None):

        if self.mySerialPort.serial_port.is_open is False:
            return

        if index is None:
            return

        myBit = (1 << index)
        print("\n")
        print("*"*80)
        print("ledsPushButtonClicked {} {:x} ".format(index, myBit))

        """
        READ
        """
        gpioLEDS = self.mySerialPort.serial_port.CPU_Read(GPIO_R_OUT)
        print("Response gpioLEDS = {}".format(gpioLEDS))

        """
        MODIFY
        """
        gpioLEDS = gpioLEDS ^ myBit
        print("Modified gpioLEDS = {:x}".format(gpioLEDS))

        """
        WRITE
        """
        self.mySerialPort.serial_port.CPU_Write(GPIO_R_OUT, gpioLEDS)

        """
        Update GPIO UI
        """
        self.GPIO_LEDS.listGPIO[15-index].updateState()
        return
