

import PyQt5
import PyQt5.QtWidgets

import UI_CentralWidget


class UI(PyQt5.QtWidgets.QMainWindow):
    """
    Top level UI class
    """

    def __init__(self, parent=None):
        super(UI, self).__init__(parent)

        # Create Main Window Elements
        self.statusBar().showMessage('Status Bar')
        self.setWindowTitle('WB Platform App')

        # Create our central widget
        self.centralWidget = UI_CentralWidget.UI_CentralWidget()
        self.setCentralWidget(self.centralWidget)

        # Display
        self.show()
