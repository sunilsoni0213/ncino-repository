.loanAutoDecisionSubLabel {
	font-size: 16px !important;
}

.loanAutoDecisionBackdrop {
	background-color: rgba(255,255,255,0.8) !important;
}

.loanAutoDecisionUpdateMessage {
	color: #1589ee;
}

.loanAutoDecisionHighlight {
	color: #06b264;
}

.loanAutoDecisionAdverseAction {
	color: rgb(194, 57, 52);
}

.loanAutoDecisionPointsChartContainer {
	width: 174px;
	height: 150px;
}

.loanAutoDecisionPointsChart {
	width: 150px;
	height: 150px;
}

.loanAutoDecisionPointsChartOverlay {
	position: absolute;
	top: 53px;
}

.loanAutoDecisionPointsChartOverlayElement {
	width: 150px;
}

.slds-compliant-col-wrapper{
	background: #fff;
	border: 1px solid #ecebea;
	box-shadow: 0 0 3px rgba(0, 0, 0, .025);
	margin-bottom: 12px;
	padding: 12px;

	-webkit-border-radius: 0 0 3px 3px;
	-moz-border-radius: 0 0 3px 3px;
	-khtml-border-radius: 0 0 3px 3px;
	border-radius: 0 0 3px 3px;
}

.noPaddingRight {
   padding-right: 0 !important;
}

.noPaddingLeft {
   padding-left: 0 !important;
}

.noPadding {
	padding-right: 0 !important;
   padding-left: 0 !important;
}

.autoHeight {
	height: auto !important;
}

@media ( min-width: 768px ) {
    .grid-divider {
        position: relative;
        padding: 0;
    }
    .grid-divider>[class*='col-'] {
        position: static;
    }
    .grid-divider>[class*='col-']:nth-child(n+2):before {
        content: "";
        border-left: 1px solid #f4f6f9;
        position: absolute;
        top: 0;
        bottom: 0;
    }
    .col-padding {
        padding: 0 15px;
    }
}

.centerDiv {
	margin: 0 auto;
}

a:focus {
	outline: none !important;
}