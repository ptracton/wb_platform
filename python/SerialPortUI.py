#! /usr/bin/env python3

"""
UI class for Serial Port hardware.  This will have an instantiation of a
Serial port.
"""

#
# The GUI libraries since we build some GUI components here
#
import PyQt5
import PyQt5.QtCore
import PyQt5.QtWidgets
import SerialPort


class SerialPortUI(PyQt5.QtCore.QObject):

    connectButtonSignal = PyQt5.QtCore.pyqtSignal()

    def __init__(self, parent=None, name="Serial Port", port="/dev/ttyUSB0",
                 baud_rate="115200", bits=8, parity=None, stop_bits=1):
        super(SerialPortUI, self).__init__()
        #
        # Serial Port
        #
        self.serial_port = SerialPort.SerialPort(port, baud_rate,
                                                 bits, parity,
                                                 stop_bits)

        #
        # GUI components
        #
        self.SerialPortName = PyQt5.QtWidgets.QLabel(name)
        self.SerialPortComboBox = PyQt5.QtWidgets.QComboBox()
        self.SerialPortComboBox.addItems(self.serial_port.get_list_of_ports())

        baud_rate_list = ["115200", "57600", "38400", "9600"]
        self.BaudRateSelected = baud_rate_list[0]
        self.BaudRateComboBox = PyQt5.QtWidgets.QComboBox()
        self.BaudRateComboBox.addItems(baud_rate_list)

        self.SerialPortLayout = PyQt5.QtWidgets.QHBoxLayout()

        self.SerialConnectButton = PyQt5.QtWidgets.QPushButton("Connect")
        self.SerialDisConnectButton = PyQt5.QtWidgets.QPushButton("Disconnect")

        self.SerialPortLayout.addWidget(self.SerialPortName)
        self.SerialPortLayout.addWidget(PyQt5.QtWidgets.QLabel("Select Port"))
        self.SerialPortLayout.addWidget(self.SerialPortComboBox)

        self.SerialPortLayout.addWidget(
            PyQt5.QtWidgets.QLabel("Select Baud Rate"))
        self.SerialPortLayout.addWidget(self.BaudRateComboBox)

        self.SerialPortLayout.addWidget(self.SerialConnectButton)
        self.SerialPortLayout.addWidget(self.SerialDisConnectButton)

        #
        # Serial port configs based on GUI selection (defaults)
        #
        # self.serial_port.setBaudrate(self.BaudRateSelected)
        # self.serial_port.setPort("/dev/ttyUSB0")

        self.SerialConnectButton.clicked.connect(self.connectClicked)
        self.SerialDisConnectButton.clicked.connect(self.disconnectClicked)

        pass

    def getLayout(self):
        """
        Return our layout for easy GUI integration
        """
        return self.SerialPortLayout

    def connectClicked(self):
        print("Connect Clicked")
        print("BaudRate {}".format(self.BaudRateComboBox.currentText()))
        print("Port {}".format(self.SerialPortComboBox.currentText()))

        if self.serial_port.is_open:
            self.serial_port.close()

        self.serial_port.setPort(self.SerialPortComboBox.currentText())
        self.serial_port.baudrate = self.BaudRateComboBox.currentText()

        try:
            self.serial_port.open()
        except:
            print("FAILED TO OPEN PORT {}".format(
                self.SerialPortComboBox.currentText()))

        if self.serial_port.is_open:
            self.SerialPortComboBox.setEnabled(False)
            self.BaudRateComboBox.setEnabled(False)

        self.connectButtonSignal.emit()
        pass

    def disconnectClicked(self):
        print("Disconnect Clicked")
        self.serial_port.close()
        self.SerialPortComboBox.setEnabled(True)
        self.BaudRateComboBox.setEnabled(True)
        pass


if __name__ == "__main__":
    import sys

    class TestUI(PyQt5.QtWidgets.QDialog):

        def __init__(self, parent=None):
            super(TestUI, self).__init__(parent)
            layOut = PyQt5.QtWidgets.QHBoxLayout()
            self.serial_port_ui = SerialPortUI()
            layOut.addLayout(self.serial_port_ui.getLayout())

            self.setLayout(layOut)
            pass

    app = PyQt5.QtWidgets.QApplication(sys.argv)
    GUI = TestUI()
    GUI.show()
    app.exec_()
