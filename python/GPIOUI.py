#! /usr/bin/env python3

"""
UI Class for interfacing with GPIOs on the Basys 3 FPGA board
"""

import sys

import PyQt5
import PyQt5.QtWidgets
import PyQt5.QtGui

import GPIO


class GPIOUI:

    def __init__(self, width=16, direction=None, label="GPIO", enableIcon=None, disableIcon=None):

        self.width = width
        self.direction = direction
        self.enableIcon = enableIcon
        self.disableIcon = disableIcon
        self.listGPIO = []
        self.gpioLayout = PyQt5.QtWidgets.QHBoxLayout()

        self.gpioLayout.addWidget(PyQt5.QtWidgets.QLabel(label))

        for x in reversed(range(self.width)):
            button = PyQt5.QtWidgets.QPushButton()
            myGPIO = GPIO.GPIO(index=x, pushButton=button,
                               enableIcon=self.enableIcon, disableIcon=self.disableIcon)
            self.gpioLayout.addWidget(myGPIO.pushButton)
            self.listGPIO.append(myGPIO)
            del(myGPIO)

        pass

    def getLayout(self):
        """
        Return our layout for easy GUI integration
        """
        return self.gpioLayout


if __name__ == "__main__":
    class TestUI(PyQt5.QtWidgets.QDialog):

        def __init__(self, parent=None):
            super(TestUI, self).__init__(parent)
            layOut = PyQt5.QtWidgets.QVBoxLayout()

            enableIcon = PyQt5.QtGui.QIcon("green_ball.png")
            disableIcon = PyQt5.QtGui.QIcon("black_ball.png")
            self.gpio_ui = GPIOUI(
                label="LEDS", enableIcon=enableIcon, disableIcon=disableIcon)

            enableIcon = PyQt5.QtGui.QIcon("upward.png")
            disableIcon = PyQt5.QtGui.QIcon("download.png")
            self.gpio_ui_sw = GPIOUI(
                label="Switches", enableIcon=enableIcon, disableIcon=disableIcon)

            layOut.addLayout(self.gpio_ui.getLayout())
            layOut.addLayout(self.gpio_ui_sw.getLayout())

            self.setLayout(layOut)
            pass

    app = PyQt5.QtWidgets.QApplication(sys.argv)
    GUI = TestUI()
    GUI.show()
    app.exec_()
