import { LightningElement } from 'lwc';
import { subscribe } from 'lightning/empApi';
import { loadScript } from 'lightning/platformResourceLoader';
import Confetti from '@salesforce/resourceUrl/Confetti'

import getActiveSteps from '@salesforce/apex/DemoSetupController.getActiveSteps';
import getActiveStep from '@salesforce/apex/DemoSetupController.getActiveStep';
import runManualStep from '@salesforce/apex/DemoSetupController.runManualStep';
import skipStep from '@salesforce/apex/DemoSetupController.skipStep';
import runStep from '@salesforce/apex/DemoSetupController.runStep';
import errStep from '@salesforce/apex/DemoSetupController.errStep';

import heading from '@salesforce/label/c.Demo_Setup_Heading';
import description from '@salesforce/label/c.Demo_Setup_Description';
import stepsComplete from '@salesforce/label/c.Demo_Setup_Steps_Complete';

export default class Installer extends LightningElement {

    labels = {
        heading,
        description,
        stepsComplete
    }

    channelName = '/event/DemoStepStatus__e';

    subscription = {};

    steps = [];

    get completed() {
        return this.steps.reduce((total, step) => {
            return step.stepStatus === 'Complete' || step.stepStatus === 'Skipped' ? total + 1 : total;
        }, 0);
    }

    get heading() {
        return this.labels.heading;
    }

    get subHeading() {
        return this.labels.description;
    }

    get stepsComplete() {
        return `${this.completed}/${this.steps.length} ${this.labels.stepsComplete}`;
    }

    get percentComplete() {
        return (this.completed / this.steps.length) * 100;
    }

    get percentWidth() {
        return `width: ${this.percentComplete}%;`
    }

    get percentProgress() {
        return `Progress: ${this.percentComplete}%;`
    }

    connectedCallback() {
        this.handleInitialLoad();
        this.setupPlatformEvtHandler();

        loadScript(this, Confetti)
            .catch(error => {
                console.log(error);
            })
    }

    handleInitialLoad() {
        getActiveSteps()
            .then(response => {
                if (response.length) {
                    this.steps = response;
                    this.markAvailableSteps();
                }
            })

            .catch(error => {
                console.log(error);
            })
    }

    updateStep(responseStep) {
        this.steps = this.steps.map(step => {
            if (step.stepNumber === responseStep.stepNumber) {
                step = { 
                    ...step, 
                    ...responseStep
                }
            }
            return step;
        });
    }

    // Enable steps if they're complete or skipped, enable next step.
    // Embraces immutability (map and spread).
    markAvailableSteps() {
        let enableNextStep = false;
        let nextStepNumber;

        this.steps = this.steps.map((step, index) => {
            if (step.stepStatus === 'Running') {
                step = {
                    ...step,
                    available: true
                }

            } else if (step.stepStatus === 'Complete' || step.stepStatus === 'Skipped') {
                
                switch (step.stepStatus) {
                    case 'Complete':
                        step = {
                            ...step,
                            available: true,
                            errorMessage: ''
                        }
                        break;
                
                    default:
                        step = {
                            ...step,
                            available: true
                        }
                        break;
                }

                enableNextStep = true;
                nextStepNumber = index + 1;

            } else if (enableNextStep && index === nextStepNumber) {
                step = {
                    ...step,
                    available: true
                }

                enableNextStep = false;

            } else if (index === 0 && !step.available) {
                step = {
                    ...step,
                    available: true
                }

            } else {
                step = {
                    ...step,
                    available: false
                }
            }
            return step;
        });
    }

    setupPlatformEvtHandler() {
        const messageCallback = (response) => {
            let payloadStep = response.data.payload.StepNumber__c;

            getActiveStep({ stepNumber: payloadStep.toFixed(1) })
                .then(response => {
                    this.updateStep(response);
                    this.markAvailableSteps();

                    if (this.percentComplete === 100) {
                        this.fireConfettiCannons();
                    }
                })

                .catch(error => {
                    console.log(error);
                })
        };

        //Subscribe to the platform event
        subscribe(this.channelName, -1, messageCallback)
            .then(response => {
                this.subscription = response;
            });
    }

    handleStateChange(event) {
        let evtStep = event.detail;

        this.steps = this.steps.map(step => {
            if (step.stepNumber === evtStep.stepNumber) {
                step = { 
                    ...step, 
                    stepStatus: 'Running'
                }
            }
            return step;
        });

        switch (evtStep.action) {
            case 'RUN':
                runStep({ stepNumber: evtStep.stepNumber.toFixed(1) })
                    .catch(error => {
                        console.log(error);
                    })
                break;

            case 'MARK_AS_COMPLETE':
                runManualStep({ stepNumber: evtStep.stepNumber.toFixed(1) })
                    .then(response => {
                        this.updateStep(response);
                        this.markAvailableSteps();

                        if (this.percentComplete === 100) {
                            this.fireConfettiCannons();
                        }
                    })

                    .catch(error => {
                        console.log(error);
                    })
                break;

            case 'SKIP':
                skipStep({ stepNumber: evtStep.stepNumber.toFixed(1) })
                    .then(response => {
                        this.updateStep(response);
                        this.markAvailableSteps();

                        if (this.percentComplete === 100) {
                            this.fireConfettiCannons();
                        }
                    })

                    .catch(error => {
                        console.log(error);
                    })
                break;

            case 'ERR':
                errStep({ stepNumber: evtStep.stepNumber.toFixed(1), errMsg: evtStep.msg })
                    .then(response => {
                        this.updateStep(response);
                        this.markAvailableSteps();
                    })

                    .catch(error => {
                        console.log(error);
                    })
                break;
        
            default:
                console.log(evtStep.action);
                break;
        }
    }

    handleRefresh() {
        location.reload();
    }

    fireConfettiCannons() {
        let end = Date.now() + (15 * 100);
        let colors = [
            '#610B0B',
            '#FFFF00',
            '#FF00BF',
            '#0040FF',
            '#585858',
            '#00FFBF',
            '#FE642E',
            '#FFBF00',
            '#0101DF',
            '#FF8000',
            '#00FF00',
            '#FF0040',
            '#A901DB',
            '#0B0B3B',
            '#FF0000'
        ];
        
        (function frame() {
            confetti({
                particleCount: 10,
                angle: 60,
                spread: 25,
                origin: {
                    x: 0,
                    y : 0.65
                },
                colors
            });
            confetti({
                particleCount: 10,
                angle: 120,
                spread: 25,
                origin: {
                    x: 1,
                    y : 0.65
                },
                colors
            });
            
            if (Date.now() < end) {
                requestAnimationFrame(frame);
            }
        }());
    }
}