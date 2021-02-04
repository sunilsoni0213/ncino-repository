import { LightningElement, api } from 'lwc';

import getURL from '@salesforce/apex/OAuthAuthorizeController.getURL';

import run from '@salesforce/label/c.Demo_Setup_Run';
import auto from '@salesforce/label/c.Demo_Setup_Auto';
import modal from '@salesforce/label/c.Demo_Setup_Modal';
import skip from '@salesforce/label/c.Demo_Setup_Skip';
import manual from '@salesforce/label/c.Demo_Setup_Manual';
import running from '@salesforce/label/c.Demo_Setup_Running';
import skipped from '@salesforce/label/c.Demo_Setup_Skipped';
import complete from '@salesforce/label/c.Demo_Setup_Complete';
import genericErrorMsg from '@salesforce/label/c.Demo_Setup_Error_Message';
import markAsComplete from '@salesforce/label/c.Demo_Setup_Mark_As_Complete';
import showErrorDetails from '@salesforce/label/c.Demo_Setup_Show_Error_Details';
import manualConfirm from '@salesforce/label/c.Demo_Setup_Steps_Manual_Confirm';
import accept from '@salesforce/label/c.Demo_Setup_Steps_Manual_Confirm_Accept';
import attention from '@salesforce/label/c.Demo_Setup_Attention';
import modalBody from '@salesforce/label/c.Demo_Setup_Modal_Body';

export default class SetupStep extends LightningElement {

    labels = {
        auto,
        manual,
        complete,
        run,
        skip,
        skipped,
        genericErrorMsg,
        showErrorDetails,
        markAsComplete,
        running,
        manualConfirm,
        accept,
        attention,
        modalBody,
        modal
    }

    @api stepNumber = 1;

    @api active = false;

    @api stepType = 'Automatic';

    @api stepTitle = '';

    @api stepStatus = 'Not Started';

    @api stepDescription = '';

    @api stepHyperlink = '';

    @api stepDependsOn = null;

    @api errorMessage = null;

    @api automationClass = null;

    @api modalPath = '';

    @api available = false;

    @api firstStep = false;

    @api lastStep = false;

    showMoreError = false;

    showPrompt = false;

    connectedCallback() {}

    get firstOrLastStep() {
        if (this.firstStep) {
            return 'step-wrapper first-step';

        } else if (this.lastStep) {
            return 'step-wrapper last-step';

        } else {
            return 'step-wrapper';
        }
    }

    get stepState() {
        if (this.errorMessage) {
            return 'error';

        } else if (this.stepStatus === 'Complete') {
            return 'success';

        } else if (this.available === true) {
            return 'active';
        }
    }

    get stepStyle() {
        return `slds-progress__item ${this.stepState}`
    }

    get svgIcon() {
        if (this.errorMessage) {
            return 'error';

        } else if (this.stepStatus === 'Complete') {
            return 'success';

        } else {
            return 'record';
        }
    }

    get svgSize() {
        return (this.stepState === 'success' || this.stepState === 'error') ? 'xx-small' : 'x-small';
    }

    get svgStyle() {
        return `slds-icon slds-icon-text-default slds-icon_${this.svgSize}`
    }

    get svgPath() {
        return `/_slds/icons/utility-sprite/svg/symbols.svg#${this.svgIcon}`
    }

    get stepIconName() {
        switch (this.stepType) {
            case 'Automatic':
                return 'standard:connected_apps';

            case 'Modal':
                return 'standard:relationship';
        
            default:
                return 'standard:custom';
        }
    }

    get stepIconStyle() {
        if (this.available === false) {
            return 'step-icon disabled';

        } else {
            switch (this.stepType) {
                case 'Automatic':
                    return 'step-icon auto';
    
                case 'Modal':
                    return 'step-icon modal';
            
                default:
                    return 'step-icon manual';
            }
        }
    }

    get stepBodyStyle() {
        if (this.available === false) {
            return `slds-media__body slds-p-left_medium slds-p-right_medium step-body disabled`

        } else {
            return `slds-media__body slds-p-left_medium slds-p-right_medium step-body`
        }
    }

    get isButtonDisabled() {
        return !this.available;
    }

    get stepIconText() {
        switch (this.stepType) {
            case 'Automatic':
                return this.labels.auto;

            case 'Modal':
                return this.labels.modal;
        
            default:
                return this.labels.manual;
        }
    }

    get hasHyperlink() {
        return this.stepHyperlink ? true : false;
    }

    get hasError() {
        return this.errorMessage ? true : false;
    }

    get errorMessageForTemplate() {
        return this.showMoreError ? `${this.labels.genericErrorMsg} \n\n${this.errorMessage}` : this.labels.genericErrorMsg;
    }

    get actionBtnLabel() {
        if (this.stepStatus === 'Complete') {
            return this.labels.complete;

        } else if (this.stepType === 'Manual-Confirm' || this.stepType === 'Manual') {
            return this.labels.markAsComplete;

        } else {
            return this.labels.run;
        }
    }

    get actionBtnIcon() {
        if (this.stepStatus === 'Complete') {
            return 'utility:check';

        } else if (this.stepType === 'Manual-Confirm' || this.stepType === 'Manual') {
            return 'utility:check';

        } else {
            return 'utility:connected_apps'
        }
    }

    get actionBtnVariant() {
        if (this.stepStatus === 'Complete') {
            return 'success';

        } else {
            return ''
        }
    }

    get actionMenuBtnLabel() {
        if (this.stepStatus === 'Skipped') {
            return this.labels.skipped;

        } else {
            return this.labels.run;
        }
    }

    get actionMenuBtnIcon() {
        if (this.stepStatus === 'Skipped') {
            return '';

        } else {
            return 'utility:connected_apps'
        }
    }

    get stepIsRunning() {
        return this.stepStatus === 'Running' ? true : false;
    }

    appendErrorMsg(event) {
        event.preventDefault();

        this.showMoreError = true;
    }

    handleErrorStateStepButtonClick(event) {
        event.preventDefault();

        if (this.stepType === 'Modal') {
            switch (this.modalPath) {
                case 'oauth':
                    getURL()
                        .then(response => {
                            window.open(response, '_blank').focus();
                            this.template.querySelector('c-modal.oauth-modal').show();
                        })
                        .catch(err => {console.log(err)});
                    break;
            
                default:
                    break;
            }
        }

        this.sendStateChangeEvt({ 
            stepNumber: this.stepNumber,
            action: 'RUN'
        });
    }

    handleStepButtonClick(event) {
        event.preventDefault();

        if (this.stepType === 'Manual-Confirm') {
            this.showPrompt = true;

        } else if (this.stepType === 'Modal') {
            switch (this.modalPath) {
                case 'oauth':
                    getURL()
                        .then(response => {
                            window.open(response, '_blank').focus();
                            this.template.querySelector('c-modal.oauth-modal').show();
                        })
                        .catch(err => {console.log(err)});
                    break;
            
                default:
                    break;
            }

        } else if (this.stepType === 'Manual') {
            this.sendStateChangeEvt({ 
                stepNumber: this.stepNumber, 
                action: 'MARK_AS_COMPLETE'
            });

        } else if (this.stepStatus === 'Not Started') {
            this.sendStateChangeEvt({ 
                stepNumber: this.stepNumber,
                action: 'RUN'
            });
            
        } else {
            console.log(this.stepStatus);
            return;
        }
    }


    handleModalOkClick() {
        this.template.querySelector('c-modal.oauth-modal').hide();

        this.sendStateChangeEvt({ 
            stepNumber: this.stepNumber, 
            action: 'MARK_AS_COMPLETE'
        });
    }

    handleModalErrorClick() {
        this.template.querySelector('c-modal.oauth-modal').hide();

        this.sendStateChangeEvt({ 
            stepNumber: this.stepNumber, 
            action: 'ERR',
            msg: 'Oauth authorization has failed'
        });
    }

    handleHyperLinkClick(event) {
        event.preventDefault();

        window.open(this.stepHyperlink, '_blank').focus();
    }

    handleSkipClick(event) {
        event.preventDefault();

        this.sendStateChangeEvt({ 
            stepNumber: this.stepNumber, 
            action: 'SKIP'
        });
    }

    handlePromptAccept(event) {
        event.preventDefault();

        this.showPrompt = false;

        this.sendStateChangeEvt({ 
            stepNumber: this.stepNumber, 
            action: 'MARK_AS_COMPLETE'
        });
    }

    sendStateChangeEvt(detail) {
        this.dispatchEvent(new CustomEvent('statechange', { detail }));
    }
}