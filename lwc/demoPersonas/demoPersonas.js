import { LightningElement } from 'lwc';
import currentUserId from '@salesforce/user/Id';

import loggedInAs from '@salesforce/label/c.Demo_Personas_Logged_In_As';
import choose from '@salesforce/label/c.Demo_Personas_Choose_Logged_In';

import settings from '@salesforce/label/c.Demo_Personas_Settings';
import login from '@salesforce/label/c.Demo_Personas_Login';
import back from '@salesforce/label/c.Demo_Personas_Back';
import save from '@salesforce/label/c.Demo_Personas_Save';
import addUser from '@salesforce/label/c.Demo_Personas_Add_User';
import removeUser from '@salesforce/label/c.Demo_Personas_Remove_User';

import getOrgId from '@salesforce/apex/UserSwitcherController.getOrgId';
import getCommunityId from '@salesforce/apex/UserSwitcherController.getCommunityId';
import getActiveUsers from '@salesforce/apex/UserSwitcherController.getActiveUsers';
import getActiveDemoUsers from '@salesforce/apex/UserSwitcherController.getActiveDemoUsers';
import updateDemoStatuses from '@salesforce/apex/UserSwitcherController.updateDemoStatuses';
import createUserSwitcherLog from '@salesforce/apex/UserSwitcherController.createUserSwitcherLog';
import getMostRecentUserSwitcherLog from '@salesforce/apex/UserSwitcherController.getMostRecentUserSwitcherLog';
import updateUserSwitcherLogToComplete from '@salesforce/apex/UserSwitcherController.updateUserSwitcherLogToComplete';

export default class DemoPersonas extends LightningElement {

    labels = {
        loggedInAs,
        choose,
        settings,
        login,
        back,
        save,
        addUser,
        removeUser
    }

    loggedInUser;

    demoUsers;

    activeUsers;

    showLoginState = true;

    demoUsersLoaded = false;

    activeUsersLoaded = false;

    orgId = '';

    updatedUsers = [];

    userProfile = '';

    originalUser = '';

    get loggedInUserIndex() {
        return 0;
    }

    get isSaveDisabled() {
        return this.updatedUsers.length ? false : true;
    }

    get selectedUsers() {
        let selected = this.activeUsers.reduce((total, user) => {
            return user.demoUser === true ? total + 1 : total;
        }, 0);

        return `${selected} Selected of ${this.activeUsers.length}`;
    }

    connectedCallback() {
        getOrgId()
            .then(response => {
                this.orgId = response;
            })
            .catch(err => {console.log(err)});

        getMostRecentUserSwitcherLog()
            .then(response => {
                let res = JSON.parse(response);

                // If we don't have a record, create one with the currentUser as the originalUser
                if (!res) {
                    this.originalUser = currentUserId;
                    let userSwitcherRecord = {
                        LoginStatus: 'Complete',
                        SourceUser: currentUserId,
                        TargetUser: currentUserId,
                        OriginalUser: currentUserId
                    }
        
                    createUserSwitcherLog({ userSwitcherRecord: JSON.stringify(userSwitcherRecord) })
                        .then(response => {
                            this.renderDemoUsers();
                        })
                        .catch(err => {console.log(err)});

                } else {
                    // Reestablish the originalUser
                    if (res.originalUser) {
                        this.originalUser = res.originalUser;
                    }

                    switch (res.status) {
                        // If we have a pending record, update the record to complete and login as the 
                        // pending target user
                        case 'Pending':
                            updateUserSwitcherLogToComplete({logId: res.id})
                                .then(response => {
                                    this.loginAsUser(res.targetUser);
                                })
                                .catch(err => {console.log(err)});
                            break;

                        // If we have a complete record, go forward without an 
                        // additional login or updating the db
                        case 'Complete':
                            this.renderDemoUsers();
                            break;
                        default:
                            console.log(res.status);
                            break;
                    }
                }
            })
            .catch(err => {console.log(err)});
    }

    renderDemoUsers() {
        getActiveDemoUsers()
            .then(response => {
                if (response.length) {
                    this.demoUsers = JSON.parse(JSON.stringify(response.filter(user => user.currentUser === false)));
                    this.loggedInUser = JSON.parse(JSON.stringify(response.filter(user => user.currentUser === true)[0]));
                }
                this.demoUsersLoaded = true;
            })
            .catch(err => {console.log(err)});
    }

    handleLoginClick(event) {
        event.preventDefault();

        let ctarget = event.currentTarget;
        let userId = ctarget.dataset.id;

        // If the user is the original user, login as the 
        // target. Else, log out first and login on the reload
        if (currentUserId !== this.originalUser) {
            let userSwitcherRecord = {
                LoginStatus: 'Pending',
                SourceUser: currentUserId,
                TargetUser: userId
            }

            createUserSwitcherLog({ userSwitcherRecord: JSON.stringify(userSwitcherRecord) })
                .then(response => {
                    window.location.pathname = '/secur/logout.jsp';
                })
                .catch(err => {console.log(err)});

        } else {
            let userSwitcherRecord = {
                LoginStatus: 'Complete',
                SourceUser: currentUserId,
                TargetUser: userId
            }

            createUserSwitcherLog({ userSwitcherRecord: JSON.stringify(userSwitcherRecord) })
                .then(response => {
                    this.loginAsUser(userId);
                })
                .catch(err => {console.log(err)});
        }
    }

    loginAsUser(userId) {
        let domain = `${this.getBaseUrl()}/servlet/servlet.su?oid=${this.orgId}`;
        let retUrl = encodeURIComponent(`${window.location.pathname}`);
        let targetUrl = encodeURIComponent(`${window.location.pathname}`);
        let connectionUrl = '';

        getCommunityId({ userId })
            .then(response => {
                if (response) {
                    connectionUrl = `${domain}&retURL=${retUrl}&sunetworkid=${response}&sunetworkuserid=${userId}`;
                    window.location.href = connectionUrl;
                } else {
                    connectionUrl = `${domain}&suorgadminid=${userId}&retURL=${retUrl}&targetURL=${targetUrl}`;
                    window.location.href = connectionUrl;
                }
            })
            .catch(err => {console.log(err)});
    }

    getBaseUrl() {
        let baseUrl = 'https://';
        let hostElems = location.host.replace('https://').split('.');

        // 'My Domain' enabled?
        let isMyDomain = hostElems[0].indexOf('--') != -1;

        // extract 'My Domain' element
        if (isMyDomain) {
            baseUrl += hostElems[0].replace('--c', '.');

        } else {
            baseUrl += `${hostElems[0]}.`;
        }

        // Cloudforce is the operative domain for connections
        baseUrl += 'cloudforce.com';

        return baseUrl;
    }

    handleSettingsClick(event) {
        event.preventDefault();

        this.activeUsersLoaded = false;
        this.showLoginState = false;

        getActiveUsers()
            .then(response => {
                if (response.length) {
                    this.activeUsers = JSON.parse(JSON.stringify(response));
                }
                this.activeUsersLoaded = true;
            })
            .catch(error => {
                console.log(error);

                this.showLoginState = true;
                this.activeUsersLoaded = true;
            })
    }

    handleBackClick() {
        this.updatedUsers = [];
        this.showLoginState = true;
    }

    handleRemoveUserClick(event) {
        event.preventDefault();

        let ctarget = event.currentTarget;
        let userId = ctarget.dataset.id;

        this.updateDemoStatus(userId, false);

        if (this.updatedUsers.includes(userId)) {
            this.updatedUsers = this.updatedUsers.filter(id => id !== userId);
        } else {
            this.updatedUsers = [...this.updatedUsers, userId];
        }
    }

    handleAddUserClick(event) {
        event.preventDefault();

        let ctarget = event.currentTarget;
        let userId = ctarget.dataset.id;

        this.updateDemoStatus(userId, true);

        if (this.updatedUsers.includes(userId)) {
            this.updatedUsers = this.updatedUsers.filter(id => id !== userId);
        } else {
            this.updatedUsers = [...this.updatedUsers, userId];
        }
    }

    updateDemoStatus(userId, demoBool) {
        this.activeUsers = this.activeUsers.map(user => {
            if (user.id === userId) {
                user = { 
                    ...user, 
                    demoUser: demoBool
                }
            }
            return user;
        });
    }

    handleSaveClick(event) {
        event.preventDefault();

        this.demoUsersLoaded = false;
        this.showLoginState = true;

        let payloadUsers = [];

        this.activeUsers.forEach(user => {
            if (this.updatedUsers.includes(user.id)) {
                payloadUsers.push(user);
            }
        });

        // We need this list to be empty now
        this.updatedUsers = [];

        // Update demoUser__c and send us back to the previous view page with updated demoUsers
        updateDemoStatuses({ stringifiedUsers: JSON.stringify(payloadUsers) })
            .then(response => {
                if (response.length) {
                    this.demoUsers = JSON.parse(JSON.stringify(response.filter(user => user.currentUser === false)));
                    this.loggedInUser = JSON.parse(JSON.stringify(response.filter(user => user.currentUser === true)[0]));
                }
                
                this.demoUsersLoaded = true;
            })
            .catch(error => {
                console.log(error);
                this.demoUsersLoaded = true;
            })
    }
}