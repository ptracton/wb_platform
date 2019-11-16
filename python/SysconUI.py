

import PyQt5
import PyQt5.QtWidgets


class SysconUI:
    """
    """

    def __init__(self):

        self.SysconVerticalLayout = PyQt5.QtWidgets.QVBoxLayout()

        # Identification Register
        self.SysconIdentificationLayout = PyQt5.QtWidgets.QHBoxLayout()
        SysconIdentificationPlatformLabelDisplay = PyQt5.QtWidgets.QLabel(
            "Platform: ")
        self.SysconIdentificationPlatformLabel = PyQt5.QtWidgets.QLabel(
            "UNKNOWN")

        SysconIdentificationMajorRevLabelDisplay = PyQt5.QtWidgets.QLabel(
            "Major Revision: ")
        self.SysconIdentificationMajorRevLabel = PyQt5.QtWidgets.QLabel(
            "UNKNOWN")

        SysconIdentificationMinorRevLabelDisplay = PyQt5.QtWidgets.QLabel(
            "Minor Revision: ")
        self.SysconIdentificationMinorRevLabel = PyQt5.QtWidgets.QLabel(
            "UNKNOWN")

        self.SysconIdentificationLayout.addWidget(
            SysconIdentificationPlatformLabelDisplay)
        self.SysconIdentificationLayout.addWidget(
            self.SysconIdentificationPlatformLabel)
        self.SysconIdentificationLayout.addWidget(
            SysconIdentificationMajorRevLabelDisplay)
        self.SysconIdentificationLayout.addWidget(
            self.SysconIdentificationMajorRevLabel)
        self.SysconIdentificationLayout.addWidget(
            SysconIdentificationMinorRevLabelDisplay)
        self.SysconIdentificationLayout.addWidget(
            self.SysconIdentificationMinorRevLabel)

        # Control Register
        self.SysconControlLayout = PyQt5.QtWidgets.QHBoxLayout()
        SysconControlLabelDisplay = PyQt5.QtWidgets.QLabel("Control: ")
        self.SysconControlLineEdit = PyQt5.QtWidgets.QLineEdit("0")
        self.SysconControlPushButton = PyQt5.QtWidgets.QPushButton("Write")

        self.SysconControlLayout.addWidget(SysconControlLabelDisplay)
        self.SysconControlLayout.addWidget(self.SysconControlLineEdit)
        self.SysconControlLayout.addWidget(self.SysconControlPushButton)

        # Status Register
        self.SysconStatusLayout = PyQt5.QtWidgets.QHBoxLayout()
        SysconStatusLabelDisplay = PyQt5.QtWidgets.QLabel("Status: ")
        self.SysconStatusLockedCheckBox = PyQt5.QtWidgets.QCheckBox("Locked")
        self.SysconStatusLockedCheckBox.setChecked(False)
        self.SysconStatusLockedCheckBox.setDisabled(True)
        self.SysconStatusLayout.addWidget(SysconStatusLabelDisplay)
        self.SysconStatusLayout.addWidget(self.SysconStatusLockedCheckBox)

        self.SysconVerticalLayout.addLayout(self.SysconIdentificationLayout)
        self.SysconVerticalLayout.addLayout(self.SysconControlLayout)
        self.SysconVerticalLayout.addLayout(self.SysconStatusLayout)

        pass

    def getLayout(self):
        return self.SysconVerticalLayout

    def updateIdentification(self, identification=None):

        if identification is None:
            return
        print("updateIdentification {:08x}".format(identification))
        platform = identification & 0x000000FF
        minor_rev = (identification & 0x00FF0000) >> 16
        major_reg = (identification & 0xFF000000) >> 24

        if platform == 0xA:
            self.SysconIdentificationPlatformLabel.setText("Basys-3 FPGA")

        self.SysconIdentificationMajorRevLabel.setText(str(major_reg))
        self.SysconIdentificationMinorRevLabel.setText(str(minor_rev))
