public class CSA_PSCConfigurationController {
	public String[] selectedStages {get;Set;}
	public String[] selectedStatus {get;Set;}
	public String[] selectedProductTypes {get;Set;}
	public String selectedExternalStages {get;Set;}
	public Boolean isBooked {get;Set;}
	public Boolean isClosed {get;Set;}
	public Boolean isReadyToTransmit {get;Set;}
	public Boolean isExcluded {get;Set;}
	public Decimal externalStageOrder {get;Set;}
	public String successMessage {get;Set;}
	public String errorMessage {get;Set;}
	public String warningMessage {get;Set;}

	public CSA_PSCConfigurationController() {
		this.clear();
	}

	public void clear() {
		this.selectedStages = new List<String>();
		this.selectedStatus = new List<String>();
		this.selectedProductTypes = new List<String>();
		this.selectedExternalStages = NONE;
		this.isBooked = false;
		this.isClosed = false;
		this.isReadyToTransmit = false;
		this.isExcluded = false;
		this.externalStageOrder = null;
		resetMessages();
	}

	public void productStateConfigSave() {
		if (!selectedStages.isEmpty()) {
			resetMessages();
			if (!selectedStatus.isEmpty()) {
				resetMessages();
				if (!selectedProductTypes.isEmpty()) {
					resetMessages();
					if (!isBooked && !isClosed && !isExcluded && !isReadyToTransmit && (selectedExternalStages == NONE) && (externalStageOrder == null || externalStageOrder == 0)) {
						this.errorMessage = System.Label.PSC_Config_Tool_Error_Usage;
					} else {
						resetMessages();
						if (((selectedExternalStages != NONE) && (externalStageOrder == null || externalStageOrder == 0)) || 
							((selectedExternalStages == NONE) && (externalStageOrder > 0))) {
							this.errorMessage = System.Label.PSC_Config_Tool_Error_External_Stage;
						} else {
							resetMessages();
							List<LLC_BI__Product_State_Config__c> productStateConfigCreateList = new List<LLC_BI__Product_State_Config__c>();
							Map<String, List<String>> stageStatusCombo = new Map<String, List<String>>();

							for (String s: selectedStages) {
								stageStatusCombo.put(s, new List<String>(selectedStatus));
							}

							if (isBooked) {
								List<LLC_BI__Product_State_Config__c> existingBooked = getProductStateConfigExisting(selectedProductTypes, isBooked, false, false, false, BLANK);
								for (String stage: stageStatusCombo.keySet()) {
									for (String status: stageStatusCombo.get(stage)) {
										for (String ptId: selectedProductTypes) {
											LLC_BI__Product_State_Config__c newB = new LLC_BI__Product_State_Config__c(
												LLC_BI__Stage__c = stage,
												LLC_BI__Status__c = status,
												LLC_BI__Is_Booked__c = isBooked,
												LLC_BI__product_Type__c = ptId,
												LLC_BI__lookupKey__c = generateRandomString(18));
											
											if (isBookedExisting(existingBooked, newB)) {
												productStateConfigCreateList.add(newB);
											}
										}
									}
								}
							}

							if (isClosed) {
								List<LLC_BI__Product_State_Config__c> existingClosed = getProductStateConfigExisting(selectedProductTypes, false, isClosed, false, false, BLANK);
								for (String stage: stageStatusCombo.keySet()) {
									for (String status: stageStatusCombo.get(stage)) {
										for (String ptId: selectedProductTypes) {
											LLC_BI__Product_State_Config__c newC = new LLC_BI__Product_State_Config__c(
												LLC_BI__Stage__c = stage,
												LLC_BI__Status__c = status,
												LLC_BI__Is_Closed__c = isClosed,
												LLC_BI__product_Type__c = ptId,
												LLC_BI__lookupKey__c = generateRandomString(18));

											if (isClosedExisting(existingClosed, newC)) {
												productStateConfigCreateList.add(newC);
											}
										}
									}
								}
							}

							if (isExcluded) {
								List<LLC_BI__Product_State_Config__c> existingExcluded = getProductStateConfigExisting(selectedProductTypes, false, false, isExcluded, false, BLANK);
								for (String stage: stageStatusCombo.keySet()) {
									for (String status: stageStatusCombo.get(stage)) {
										for (String ptId: selectedProductTypes) {
											LLC_BI__Product_State_Config__c newE = new LLC_BI__Product_State_Config__c(
												LLC_BI__Stage__c = stage,
												LLC_BI__Status__c = status,
												LLC_BI__Is_Excluded_From_Stage_Duration__c = isExcluded,
												LLC_BI__product_Type__c = ptId,
												LLC_BI__lookupKey__c = generateRandomString(18));

											if (isExcludedExisting(existingExcluded, newE)) {
												productStateConfigCreateList.add(newE);
											}
										}
									}
								}
							}

							if (isReadyToTransmit) {
								List<LLC_BI__Product_State_Config__c> existingTransmit = getProductStateConfigExisting(selectedProductTypes, false, false, false, isReadyToTransmit, BLANK);
								for (String stage: stageStatusCombo.keySet()) {
									for (String status: stageStatusCombo.get(stage)) {
										for (String ptId: selectedProductTypes) {
											LLC_BI__Product_State_Config__c newT = new LLC_BI__Product_State_Config__c(
												LLC_BI__Stage__c = stage,
												LLC_BI__Status__c = status,
												LLC_BI__Is_Ready_To_Transmit__c = isReadyToTransmit,
												LLC_BI__product_Type__c = ptId,
												LLC_BI__lookupKey__c = generateRandomString(18));

											if (isTransmitExisting(existingTransmit, newT)) {
												productStateConfigCreateList.add(newT);
											}
										}
									}
								}
							}
							
							if (String.isNotBlank(selectedExternalStages)) {
								List<LLC_BI__Product_State_Config__c> existingExternalStage = getProductStateConfigExisting(selectedProductTypes, false, false, false, false, selectedExternalStages);
								for (String stage: stageStatusCombo.keySet()) {
									for (String status: stageStatusCombo.get(stage)) {
										for (String productTypeId: selectedProductTypes) {
											LLC_BI__Product_State_Config__c newES = new LLC_BI__Product_State_Config__c(
												LLC_BI__Stage__c = stage,
												LLC_BI__Status__c = status,
												LLC_BI__External_Stage__c = selectedExternalStages,
												LLC_BI__External_Stage_Order__c = externalStageOrder,
												LLC_BI__product_Type__c = productTypeId,
												LLC_BI__lookupKey__c = generateRandomString(18));
											
											if (isExternalExisting(existingExternalStage, newES)) {
												productStateConfigCreateList.add(newES);
											}
										}
									}
								}
							}
            
							if (!productStateConfigCreateList.isEmpty()) {
								try {          
									Database.insert(productStateConfigCreateList);
									this.successMessage = System.Label.PSC_Config_Tool_Success_Created;
								} catch (Exception ex) {
									this.errorMessage = ex.getMessage();
								}
							} else {
								this.warningMessage = System.Label.PSC_Config_Tool_Warning_No_Data;
							}
						}
					}
				} else {
					this.errorMessage = System.Label.PSC_Config_Tool_Error_Product_Types;
				}
			} else {
				this.errorMessage = System.Label.PSC_Config_Tool_Error_Status;
			}
		} else {
			this.errorMessage = System.Label.PSC_Config_Tool_Error_Stages;
		}
	}

	private List<LLC_BI__Product_State_Config__c> getProductStateConfigExisting(List<String> productTypes, 
																				Boolean booked, 
																				Boolean closed, 
																				Boolean excluded, 
																				Boolean transmit, 
																				String externalStage) {
		List<LLC_BI__Product_State_Config__c> pscQuery = new List<LLC_BI__Product_State_Config__c>();
		
		if (booked) {
			pscQuery = [SELECT
							Id, 
							LLC_BI__Stage__c, 
							LLC_BI__Status__c, 
							LLC_BI__Product_Type__c, 
							LLC_BI__Is_Booked__c 
						FROM 
							LLC_BI__Product_State_Config__c
						WHERE 
							LLC_BI__Product_Type__c IN :productTypes
						AND 
							LLC_BI__Is_Booked__c = :booked LIMIT 1000];
		} else if (closed) {
			pscQuery = [SELECT
							Id, 
							LLC_BI__Stage__c, 
							LLC_BI__Status__c, 
							LLC_BI__Product_Type__c, 
							LLC_BI__Is_Closed__c 
						FROM 
							LLC_BI__Product_State_Config__c 
						WHERE 
							LLC_BI__Product_Type__c IN :productTypes
						AND 
							LLC_BI__Is_Closed__c = :closed LIMIT 1000];
		} else if (excluded) {
			pscQuery = [SELECT
							Id,
							LLC_BI__Stage__c,
							LLC_BI__Status__c, 
							LLC_BI__Product_Type__c, 
							LLC_BI__Is_Excluded_From_Stage_Duration__c
						FROM 
							LLC_BI__Product_State_Config__c
						WHERE 
							LLC_BI__Product_Type__c IN :productTypes
						AND 
							LLC_BI__Is_Excluded_From_Stage_Duration__c = :excluded LIMIT 1000];
		} else if (transmit) {
			pscQuery = [SELECT
							Id,
							LLC_BI__Stage__c,
							LLC_BI__Status__c, 
							LLC_BI__Product_Type__c,  
							LLC_BI__Is_Ready_To_Transmit__c
						FROM 
							LLC_BI__Product_State_Config__c
						WHERE 
							LLC_BI__Product_Type__c IN :productTypes
						AND 
							LLC_BI__Is_Ready_To_Transmit__c = :transmit LIMIT 1000];
		} else if (String.isNotBlank(externalStage)) {
			pscQuery = [SELECT
							Id,
							LLC_BI__Stage__c,
							LLC_BI__Status__c, 
							LLC_BI__Product_Type__c, 
							LLC_BI__External_Stage__c
						FROM 
							LLC_BI__Product_State_Config__c
						WHERE 
							LLC_BI__Product_Type__c IN :productTypes
						AND 
							LLC_BI__External_Stage__c = :externalStage LIMIT 1000];
		}

		return pscQuery;
	}

	private static Boolean isBookedExisting(List<LLC_BI__Product_State_Config__c> existingPSC, LLC_BI__Product_State_Config__c newPSC) {
		Boolean value = True;

		for (LLC_BI__Product_State_Config__c psc: existingPSC) {
			if (psc.LLC_BI__Stage__c == newPSC.LLC_BI__Stage__c &&
				psc.LLC_BI__Status__c == newPSC.LLC_BI__Status__c &&
				psc.LLC_BI__Product_Type__c == newPSC.LLC_BI__Product_Type__c &&
				psc.LLC_BI__Is_Booked__c == newPSC.LLC_BI__Is_Booked__c) {
				value= false;
			}
		}

		return value;
	}

	private static Boolean isClosedExisting(List<LLC_BI__Product_State_Config__c> existingPSC, LLC_BI__Product_State_Config__c newPSC) {
		Boolean value = True;

		for (LLC_BI__Product_State_Config__c psc: existingPSC) {
			if (psc.LLC_BI__Stage__c == newPSC.LLC_BI__Stage__c &&
				psc.LLC_BI__Status__c == newPSC.LLC_BI__Status__c &&
				psc.LLC_BI__Product_Type__c == newPSC.LLC_BI__Product_Type__c &&
				psc.LLC_BI__Is_Closed__c == newPSC.LLC_BI__Is_Closed__c) {
				value= false;
			}
		}

		return value;
	}

	private static Boolean isExcludedExisting(List<LLC_BI__Product_State_Config__c> existingPSC, LLC_BI__Product_State_Config__c newPSC) {
		Boolean value = True;

		for (LLC_BI__Product_State_Config__c psc: existingPSC) {
			if (psc.LLC_BI__Stage__c == newPSC.LLC_BI__Stage__c &&
				psc.LLC_BI__Status__c == newPSC.LLC_BI__Status__c &&
				psc.LLC_BI__Product_Type__c == newPSC.LLC_BI__Product_Type__c &&
				psc.LLC_BI__Is_Excluded_From_Stage_Duration__c == newPSC.LLC_BI__Is_Excluded_From_Stage_Duration__c) {
				value= false;
			}
		}

		return value;
	}

	private static Boolean isTransmitExisting(List<LLC_BI__Product_State_Config__c> existingPSC, LLC_BI__Product_State_Config__c newPSC) {
		Boolean value = True;

		for (LLC_BI__Product_State_Config__c psc: existingPSC) {
			if (psc.LLC_BI__Stage__c == newPSC.LLC_BI__Stage__c &&
				psc.LLC_BI__Status__c == newPSC.LLC_BI__Status__c &&
				psc.LLC_BI__Product_Type__c == newPSC.LLC_BI__Product_Type__c &&
				psc.LLC_BI__Is_Ready_To_Transmit__c == newPSC.LLC_BI__Is_Ready_To_Transmit__c) {
				value= false;
			}
		}

		return value;
	}

	private static Boolean isExternalExisting(List<LLC_BI__Product_State_Config__c> existingPSC, LLC_BI__Product_State_Config__c newPSC) {
		Boolean value = True;

		for (LLC_BI__Product_State_Config__c psc: existingPSC) {
			if (psc.LLC_BI__Stage__c == newPSC.LLC_BI__Stage__c &&
				psc.LLC_BI__Status__c == newPSC.LLC_BI__Status__c &&
				psc.LLC_BI__Product_Type__c == newPSC.LLC_BI__Product_Type__c &&
				psc.LLC_BI__External_Stage__c == newPSC.LLC_BI__External_Stage__c) {
				value= false;
			}
		}

		return value;
	}
	
	public List<SelectOption> getStagePicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
        for (Schema.PicklistEntry p: LLC_BI__Loan__c.LLC_BI__Stage__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

    public List<SelectOption> getStatusPicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
        for (Schema.PicklistEntry p: LLC_BI__Loan__c.LLC_BI__Status__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

	public List<SelectOption> getExternalStagePicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
		newSO.add(new SelectOption(NONE, NONESELECT));
        for (Schema.PicklistEntry p: LLC_BI__Product_State_Config__c.LLC_BI__External_Stage__c.getDescribe().getPicklistValues()) {
            newSO.add(new SelectOption(p.value, p.label));
        }

        return newSO;
    }

	public List<SelectOption> getProductTypePicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
        for (LLC_BI__Product_Type__c pt: getProductTypes()) {
            newSO.add(new SelectOption(pt.Id, productTypeLabel(pt.LLC_BI__Product_Line__r.Name, pt.Name)));
        }

        return newSO;
    }

	private List<LLC_BI__Product_Type__c> getProductTypes() {
		return [SELECT
					Id, 
					Name,
					LLC_BI__Product_Line__r.Name
				FROM
					LLC_BI__Product_Type__c];
	}

	private static String productTypeLabel(String line, String ptype) {
		return line + BLANKDASHBLANK + ptype;
	}

	private void resetMessages() {
		this.successMessage = null;
		this.errorMessage = null;
		this.warningMessage = null;
	}

	public static String generateRandomString(Integer len) {
		final String chars = NUMBERSFORRANDOMIZER;
		String randStr = BLANK;
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr; 
	}

	private static final String NUMBERSFORRANDOMIZER = '0123456789';
	private static final String BLANK = '';
	private static final String NONE = 'None';
	private static final String NONESELECT = '-- None --';
	private static final String BLANKDASHBLANK = ' - ';
}