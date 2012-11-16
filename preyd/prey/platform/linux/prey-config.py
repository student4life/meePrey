#!/usr/bin/env python

################################################
# Prey Configurator for Linux using Pyside
# By Najath Abdul Azeez`
# 
################################################

################################################
# base includes
################################################

import sys
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import QDeclarativeView
import os
# from xml.dom.minidom import parseString
import re
import urllib

app_name = 'prey-config'
lang_path = 'lang'
script_path = os.sys.path[0]

################################################
# gettext localization
################################################

import locale
import gettext
# locale.setlocale(locale.LC_ALL, '')
# locale.bindtextdomain(app_name, lang_path)
gettext.bindtextdomain(app_name, lang_path)
gettext.textdomain(app_name)
_ = gettext.gettext

################################################
# vars and such
################################################

PREY_PATH = '/opt/prey'
CONFIG_FILE = PREY_PATH + '/config'
DAEMON_FILE = '/etc/init/apps/preyd.conf'
CONTROL_PANEL_URL = 'http://control.preyproject.com'
CONTROL_PANEL_URL_SSL = 'https://control.preyproject.com'
VERSION = os.popen("cat " + PREY_PATH + "/version 2> /dev/null").read().strip().replace('version=', '').replace("'",'')

#Autogenerator for QObject
def AutoQObject(*class_def, **kwargs):
    class Object(QObject):
        def __init__(self, **kwargs):
            QObject.__init__(self)
            for key, val in class_def:
                self.__dict__['_'+key] = kwargs.get(key, val())
 
        def __repr__(self):
            values = ('%s=%r' % (key, self.__dict__['_'+key]) \
                    for key, value in class_def)
            return '<%s (%s)>' % (kwargs.get('name', 'QObject'), ', '.join(values))
 
        for key, value in class_def:
            nfy = locals()['_nfy_'+key] = Signal()
 
            def _get(key):
                def f(self):
                    return self.__dict__['_'+key]
                return f
 
            def _set(key):
                def f(self, value):
                    self.__dict__['_'+key] = value
                    self.__dict__['_nfy_'+key].emit()
                return f
 
            set = locals()['_set_'+key] = _set(key)
            get = locals()['_get_'+key] = _get(key)
 
            locals()[key] = Property(value, get, set, notify=nfy)
 
    return Object

#Create Vars object
Vars = AutoQObject(
        ('delay', int),
        ('auto_connect', str),
        ('extended_headers', str),
        ('lang', str),
        ('check_url', str),
        ('post_method', str),
        ('api_key', str),
        ('device_key', str),
        ('mail_to', str),
        ('smtp_server', str),
        ('smtp_username', str),
        ('user_name', str),
        ('email', str),
        ('password', str),
        ('password_confirm', str),
        name='Vars')


# Our main window
class MainWindow(QObject):
   
    ################################################
    # validations
    ################################################

    def validate_email(self, string):
        if len(string) > 7:
            if re.match("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$", string) != None:
                return True
        return False

    def validate_fields(self):
        if self.curVars.user_name == '':
            self.rootO.show_alert("Empty name!", "Please type in your name.",False)
            return False
        if self.validate_email(self.curVars.email) == False:
            self.rootO.show_alert("Invalid email", "Please make sure the email address you typed is valid.",False)
            return False
        if len(self.curVars.password) < 6:
            self.rootO.show_alert("Bad password", "Password should contain at least 6 chars. Please try again.",False)
            return False
        elif self.curVars.password != self.curVars.password_confirm:
            self.rootO.show_alert("Passwords don't match", "Please make sure both passwords match!",False)
            return False
        return True

    ################################################
    # setting getting
    ################################################

    def prey_exists(self):
        if not os.path.exists(PREY_PATH + '/core'):
            self.rootO.show_alert("Prey not installed", "Couldn't find a Prey installation on this system. Sorry.", True)
        else:
            return True

    def is_config_writable(self):
        command = 'if [ ! -w "'+PREY_PATH+'/config" ]; then echo 1; fi'
        no_access = os.popen(command).read().strip()
        if no_access == '1':
            self.rootO.show_alert("Unauthorized", "You don't have access to manage Prey's configuration. Sorry.", True)
        else:
            return True

    def get_setting(self, var):
        command = 'grep \''+var+'=\' '+CONFIG_FILE+' | sed "s/'+var+'=\'\(.*\)\'/\\1/"'
        return os.popen(command).read().strip()

    def get_current_settings(self):

        delay = os.popen("/opt/cron/bin/crontab -l | grep prey | cut -c 3-4").read()
        #command = 'cat '+DAEMON_FILE+' | grep preyd | cut -d \' \' -f 3'
        #self.curVars.delay = int(os.popen(command).read())
        if not delay:
            self.curVars.delay = 30
        else:
            self.curVars.delay = int(delay)

        self.curVars.auto_connect = self.get_setting('auto_connect')
        self.curVars.extended_headers = self.get_setting('extended_headers')

        self.curVars.lang = self.get_setting('lang')
        self.curVars.check_url = self.get_setting('check_url')
        self.curVars.post_method = self.get_setting('post_method')

        self.curVars.api_key = self.get_setting('api_key')
        self.curVars.device_key = self.get_setting('device_key')

        self.curVars.mail_to = self.get_setting('mail_to')
        self.curVars.smtp_server = self.get_setting('smtp_server')
        self.curVars.smtp_username = self.get_setting('smtp_username')

    def check_if_configured(self):
        if self.curVars.post_method == 'http' and self.curVars.api_key == '':
            return False
        else:
            return True

    ################################################
    # setting settings
    ################################################

    def save(self, param, value):
        if param == 'check_url': value = value.replace('/', '\/')
        command = 'sed -i -e "s/'+param+'=\'.*\'/'+param+'=\''+value+'\'/" '+ CONFIG_FILE
        os.system(command)

    @Slot(int)
    def apply_main_settings(self,delay):
        # save('lang', text('lang'))
        self.save('auto_connect', self.curVars.auto_connect)
        self.save('extended_headers', self.curVars.extended_headers)


        # check and change the crontab interval
        if delay != int(self.curVars.delay):
            # print 'Updating delay in crontab...'
            #sub1 =  ' -e \'s/preyd '+str(self.curVars.delay)+'/preyd '+str(delay)+'/g\' '
            #sub2 =  ' -e \'s/every '+str(self.curVars.delay)+'/every '+str(delay)+'/g\' '
            #command = 'sed -i ' + sub1 + sub2 + DAEMON_FILE
            #os.system(command)
            os.system('(/opt/cron/bin/crontab -l | tail -n+4 | grep -v prey; echo "*/'+str(delay)+' * * * * aegis-exec -s /opt/prey/prey.sh > /var/log/prey.log") | /opt/cron/bin/crontab -')

        if self.check_if_configured() == False:
            self.rootO.show_alert("All good.", "Configuration saved. Remember you still need to set up your posting method, otherwise Prey won't work!", True)
        else:
            self.rootO.show_alert("All good.", "Configuration saved!", True)

    @Slot()
    def create_new_user(self):
        if self.validate_fields():
            self.create_user()

    def apply_control_panel_settings(self):

        if self.curVars.post_method != 'http':
            self.save('post_method', 'http')

        if self.curVars.check_url != CONTROL_PANEL_URL:
            self.save('check_url', CONTROL_PANEL_URL)

        # we could eventually use the email as a checking method to remove prey
        # i.e. "under which email was this account set up?"
        # self.save('mail_to', self.email)
        self.save('api_key', self.curVars.api_key)

        if self.curVars.device_key != "":
            self.save('device_key', self.curVars.device_key)

    @Slot(str)
    def apply_standalone_settings(self,password):

        if self.curVars.post_method != 'email':
            self.save('post_method', 'email')

        self.save('check_url', self.curVars.check_url)
        self.save('mail_to', self.curVars.mail_to)
        self.save('smtp_server', self.curVars.smtp_server)
        self.save('smtp_username', self.curVars.smtp_username)

        #smtp_password = self.('smtp_password')

        if password != '':
            encoded_pass = os.popen('echo -n "'+ password +'" | openssl enc -base64').read().strip()
            self.save('smtp_password', encoded_pass)

        self.exit_configurator()

    def exit_configurator(self):
        self.run_prey()
        self.rootO.show_alert(_("Success"), _("Configuration saved! Your device is now setup and being tracked by Prey. Happy hunting!"), True)

    def run_prey(self):
        os.system(PREY_PATH + '/run ')

    ################################################
    # control panel api
    ################################################

    def report_connection_issue(self, result):
        print("Connection error. Response from server: " + result)
        self.rootO.show_alert("Problem connecting", "We seem to be having a problem connecting to the Prey Control Panel. This is likely a temporary issue. Please try again in a few moments.",False)

    def user_has_available_slots(self, string):
        matches = re.search(r"<available_slots>(\w*)</available_slots>", string)
        if matches and int(matches.groups()[0]) > 0:
            return True
        else:
            return False

    def get_api_key(self, string):
        matches = re.search(r"<key>(\w*)</key>", string)
        if matches:
            self.curVars.api_key = matches.groups()[0]

    @Slot(result=int)
    def create_device_list(self):
        self.deviceList = self.rootO.findChild(QObject,"deviceList")
        self.deviceList.clear()
        for device in self.deviceNames:
            self.deviceList.add(device)
        return self.chosen

    def get_device_keys(self, string, has_available_slots):
        hostname = os.popen("hostname").read().strip()
        index = -1
        self.deviceKeys = []
        self.deviceNames = []
        self.chosen = index
        matches = re.findall(r"<device>\s*<key>(\w*)</key>.*?<title>([\.\s\w]*)</title>\s*</device>", string, re.DOTALL)
        for match in matches:
            index += 1
            key = match[0]
            title = match[1]
            self.deviceKeys.append(key)
            self.deviceNames.append(title)
            if key == self.curVars.device_key:    #set the choice because we have a matching device key
                self.chosen = index
            elif title.lower() == hostname.lower and self.chosen < 0:    #set the choice because we likely have a matching title (but device key takes precedence)
                self.chosen = index
        if index < 0:
            self.rootO.show_alert("No devices exist", "There are no devices currently defined in your Control Panel.\n\nPlease select the option to create a new device.",False)
            return False
        if self.chosen < 0:
            self.chosen = 0

        return True

    def create_user(self):
        params = urllib.urlencode({'user[name]': self.curVars.user_name, 'user[email]': self.curVars.email, 'user[password]': self.curVars.password, 'user[password_confirmation]' : self.curVars.password_confirm})
        result = os.popen('curl -i -s -k --connect-timeout 10 '+ CONTROL_PANEL_URL_SSL + '/users.xml -d \"'+params+'\"').read().strip()

        if result.find("<key>") != -1:
            self.get_api_key(result)
            self.curVars.device_key = ""
        elif result.find("Email has already been taken") != -1:
            self.rootO.show_alert("Email has already been taken", "That email address already exists! If you signed up previously, please go back and select the Existing User option.",False)
            return
        else:
            self.rootO.show_alert("Couldn't create user!", "There was a problem creating your account. Please make sure the email address you entered is valid, as well as your password.",False)
            return

        self.apply_control_panel_settings()
        self.run_prey()
        self.rootO.show_alert("Account created!", "Your account has been succesfully created and configured in Prey's Control Panel.\n\nPlease check your inbox now, you should have received a verification email.", True)

    @Slot(bool, result=bool)
    def get_existing_user(self, show_devices):
        email = self.curVars.email
        password = self.curVars.password
        print email+' '+password
        result = os.popen('curl -i -s -k --connect-timeout 10 '+ CONTROL_PANEL_URL_SSL + '/profile.xml -u '+email+":'"+password+"'").read().strip()

        if result.find('401 Unauthorized') != -1:
            self.rootO.show_alert("User does not exist", "Couldn't log you in. Remember you need to activate your account opening the link we emailed you.\n\nIf you forgot your password please visit preyproject.com.",False)
            return False

        if result.find("<user>") != -1:
            self.get_api_key(result)
        else:
            self.report_connection_issue(result)
            return False

        has_available_slots = self.user_has_available_slots(result)
        if not has_available_slots and not show_devices:
            self.rootO.show_alert("Not allowed",  "It seems you've reached your limit for devices!\n\nIf you had previously added this PC, you should select the \"Device already exists\" option to select the device from a list of the ones you have already created.\n\nIf this is a new device, you can also upgrade to a Pro Account to increase your slot count and get access to additional features. For more information, please check\nhttp://preyproject.com/plans.",False)
            return False

        if show_devices:
            result = os.popen('curl -i -s -k --connect-timeout 10 '+ CONTROL_PANEL_URL_SSL + '/devices.xml -u '+email+":'"+password+"'").read().strip()
            if result.find("</devices>") != -1:
                return self.get_device_keys(result,has_available_slots)
            else:
                self.report_connection_issue(result)
                return False
        else:
            self.curVars.device_key = ""
            self.apply_control_panel_settings()
            self.exit_configurator()

    @Slot(int)
    def apply_device_settings(self,index):
        self.curVars.device_key = self.deviceKeys[index]
        self.apply_control_panel_settings()
        self.exit_configurator()




    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent)
        # Create the Qt Application
        self.app = QApplication(["Prey-Config"])
        self.app.setWindowIcon(QIcon(''))
        self.view = QDeclarativeView()
        #self.setWindowTitle("Main Window")

        #get rootContext of QDeclarativeView
        self.context = self.view.rootContext()
        #make this class available to QML files as 'main' context
        self.context.setContextProperty('main', self)
        #create variables
        self.curVars = Vars()
        #make curVars available to QML files as 'vars' context
        self.context.setContextProperty('vars', self.curVars)
        # QML resizes to main window
        self.view.setResizeMode(QDeclarativeView.SizeRootObjectToView)
        # Renders './qml/main.qml'
        self.view.setSource(QUrl.fromLocalFile('./qml/main.qml'))
        #get rootObject
        self.rootO = self.view.rootObject()

        #connect quit signal
        self.view.engine().quit.connect(self.quit_app)

        #check for prey installation, write acess to config file, and configurationstatus
        if self.prey_exists():
            if self.is_config_writable():
                self.get_current_settings()
                if self.check_if_configured() == False:
                    self.rootO.show_alert('Welcome!',"It seems this is the first time you run this setup. Please set up your reporting method now, otherwise Prey won't work!",False)
                    os.system('(/opt/cron/bin/crontab -l | tail -n+4 | grep -v prey; echo "*/30 * * * * aegis-exec -s /opt/prey/prey.sh > /var/log/prey.log") | /opt/cron/bin/crontab -')

 
 
    def quit_app(self):
        self.view.hide()
        self.app.exit()

if __name__ == '__main__':
    print sys.argv[0]
    os.chdir(os.path.dirname(sys.argv[0]))
    # Create and show the main window
    window = MainWindow()
    window.view.showFullScreen()
    # Run the main Qt loop
    sys.exit(window.app.exec_())

