import PyQt5
import PyQt5.QtWidgets
import PyQt5.QtGui
import PyQt5.QtCore


class MemoryTabWidgetSignal(PyQt5.QtCore.QObject):
    """

    """
    Signal = PyQt5.QtCore.pyqtSignal()

    def __init__(self):
        super(MemoryTabWidgetSignal, self).__init__()


class MemoryTabWidgetPushButtonSignal(PyQt5.QtCore.QObject):
    """

    """
    pushButtonSignal = PyQt5.QtCore.pyqtSignal(int, int)

    def __init__(self):
        super(MemoryTabWidgetPushButtonSignal, self).__init__()


class MemoryTabWidget(PyQt5.QtWidgets.QWidget):
    """

    """

    def __init__(self):
        super(MemoryTabWidget, self).__init__()
        self.signal = MemoryTabWidgetSignal()
        self.clicked = MemoryTabWidgetPushButtonSignal()

        self.MemoryTabWidgetLayout = PyQt5.QtWidgets.QVBoxLayout()

        memoryReadHBoxLayout = PyQt5.QtWidgets.QHBoxLayout()
        memoryAddressLabel = PyQt5.QtWidgets.QLabel("Memory Address")
        self.memoryAddressLineEdit = PyQt5.QtWidgets.QLineEdit("0x90000000")

        memoryCountLabel = PyQt5.QtWidgets.QLabel(
            "Number of locations to read")
        self.memoryCountLineEdit = PyQt5.QtWidgets.QLineEdit("1")

        self.memoryReadPushButton = PyQt5.QtWidgets.QPushButton("Read Memory")
        memoryReadHBoxLayout.addWidget(memoryAddressLabel)
        memoryReadHBoxLayout.addWidget(self.memoryAddressLineEdit)
        memoryReadHBoxLayout.addWidget(memoryCountLabel)
        memoryReadHBoxLayout.addWidget(self.memoryCountLineEdit)
        memoryReadHBoxLayout.addWidget(self.memoryReadPushButton)

        self.tableWidget = PyQt5.QtWidgets.QTableWidget()
        #self.tableWidget = PyQt5.QtWidgets.QTableView()
        # set row count
        self.tableWidget.setRowCount(2)
        # set column count
        self.tableWidget.setColumnCount(5)

        self.tableWidget.setHorizontalHeaderLabels(
            ["Offset", "0x0", "0x04", "0x08", "0x0C"])
        addressWidget = PyQt5.QtWidgets.QTableWidgetItem()
        addressWidget.setText("0x90000000")
        self.tableWidget.setItem(1, 0, addressWidget)

        self.MemoryTabWidgetLayout.addLayout(memoryReadHBoxLayout)
        self.MemoryTabWidgetLayout.addWidget(self.tableWidget)

        self.memoryReadPushButton.clicked.connect(self.memoryReadClicked)

        pass

    def memoryReadClicked(self):
        """

        :return:
        """
        print("Starting Address {}".format(self.memoryAddressLineEdit.text()))
        print("Number of Locations {}".format(self.memoryCountLineEdit.text()))

        self.tableWidget.clearContents()
        self.tableWidget.setRowCount(1)

        if self.memoryAddressLineEdit.text() == '':
            addressString = "0x90000000"
        else:
            addressString = self.memoryAddressLineEdit.text()

        address = int(addressString, 16)

        if self.memoryCountLineEdit.text() == '':
            memoryCountString = "1"
        else:
            memoryCountString = self.memoryCountLineEdit.text()

        memoryCount = int(memoryCountString)
        print("memoryReadClicked Address={:08x} Count={}".format(
            address, memoryCount))
        self.clicked.pushButtonSignal.emit(address, memoryCount)

    def updateMemoryTable(self, address=None, value=None):
        """

        :param address:
        :param value:
        :return:
        """

        if address is None or value is None:
            return
        print("updateMemoryTable {:08x} {:08x}".format(address, value))

        baseAddress = int(self.memoryAddressLineEdit.text(), 16)
        row = int(((address - baseAddress) & 0xFFFFFFF0)/16)+1
        column = int((address & 0x0000000F)/4 + 1)
        #print("Location Row = {} Column = {}".format(row, column))

        # if we are using a row that doesn't exist yet,
        # make sure it does exist by inserting it
        if row > self.tableWidget.rowCount()-1:
            self.tableWidget.insertRow(row)

        addressWidget = PyQt5.QtWidgets.QTableWidgetItem()
        addressWidget.setText("{:08x}".format(baseAddress + (4*(row-1))))
        self.tableWidget.setItem(row, 0, addressWidget)

        valueWidget = PyQt5.QtWidgets.QTableWidgetItem()
        valueWidget.setText("{:08x}".format(value))
        self.tableWidget.setItem(row, column, valueWidget)

    def getLayout(self):
        return self.MemoryTabWidgetLayout
