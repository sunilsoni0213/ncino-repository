<div ng-show="dialog.isRendered">
	<div role="dialog" tabindex="-1" aria-labelledby="dialogHeader" class="slds-modal slds-fade-in-open">
		<div class="slds-modal__container" n-style="pso-modal-container">
			<div class="slds-modal__header" n-style="pso-modal-header">
				<button class="slds-button slds-modal__close slds-button--icon-inverse" title="{{dialog.labels.cancel}}">
					<svg class="slds-button__icon slds-button__icon--large" aria-hidden="true">
						<use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#close"></use>
					</svg>
					<span class="slds-assistive-text" ng-bind="dialog.labels.cancel"></span>
				</button>
				<h2 id="dialogHeader" class="slds-text-heading--medium" ng-bind="dialog.labels.header"
					n-style="pso-modal-header-text">
				</h2>
			</div>
			<div class="slds-modal__content slds-p-around--medium" n-style="pso-modal-body">
				<p class="portal-center-text" ng-bind="dialog.labels.body"></p>
			</div>
			<div class="slds-modal__footer" n-style="pso-modal-footer">
				<button class="slds-button slds-button--neutral" ng-bind="dialog.labels.cancel"
					ng-click="cancel()" n-style="pso-button-secondary">
				</button>
				<button class="slds-button slds-button--brand" ng-bind="dialog.labels.confirm"
					ng-click="confirm()" n-style="pso-button-primary">
				</button>
			</div>
		</div>
	</div>
	<div class="slds-backdrop slds-backdrop--open" n-style="pso-modal-background"></div>
</div>