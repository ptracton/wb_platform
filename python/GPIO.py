#! /usr/bin/env python3

import enum

import PyQt5
import PyQt5.QtCore


class GPIODirection(enum.Enum):
    INPUT = 0
    OUTPUT = 1
    BIDIRECTIONAL = 2
    ALTERNATE = 3


class GPIOState(enum.Enum):
    OFF = 0
    ON = 1


class GPIO(PyQt5.QtCore.QObject):

    """
    Container class for the GPIO on the FPGA board
    """
    pushButtonSignal = PyQt5.QtCore.pyqtSignal(int)

    def __init__(self, state=GPIOState.OFF, direction=GPIODirection.INPUT, index=None, enableIcon=None, disableIcon=None, pushButton=None):
        super(GPIO, self).__init__()
        self.direction = direction
        self.state = state
        self.index = index
        self.enableIcon = enableIcon
        self.disableIcon = disableIcon
        self.currentIcon = self.disableIcon
        self.pushButton = pushButton
        self.pushButton.clicked.connect(self.clicked)
        self.pushButton.setIcon(self.currentIcon)
        # self.pushButton.setText(str(index))

    def updateState(self):
        print("Update State {}".format(self.index))
        if self.state == GPIOState.OFF:
            self.state = GPIOState.ON
            self.currentIcon = self.enableIcon
        elif self.state == GPIOState.ON:
            self.state = GPIOState.OFF
            self.currentIcon = self.disableIcon

        self.pushButton.setIcon(self.currentIcon)
        return

    def clicked(self):
        """
        """
        print("Clicked {} {}".format(self.index, self.state))
        self.pushButtonSignal.emit(self.index)
        return
