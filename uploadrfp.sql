USE [StreamFinTrn]
GO
/****** Object:  StoredProcedure [dbo].[uspg_uploadrfp]    Script Date: 09/02/2018 16.01.59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Reichan Abdikar>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[uspg_uploadrfp] 
	-- Add the parameters for the stored procedure here
	@TransID numeric(15,0) = 0,
	@Change_User_Id VARCHAR(10) = '',
	@COMPANY_CODE numeric(10,0) = 0,
	@GroupCode varchar(10) = '',
	@Ref_Sys_No numeric(15,0) = 0,
	@Ref_Doc_No varchar(30) = '',
	@Journal_Sys_No numeric(15,0) = 0 output,
	@Journal_Doc_No varchar(30) = '' output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Src_Code VARCHAR(10) = '',@Trx_Type VARCHAR(10) = ''
	DECLARE @MAXCOUNT INT = 0,@COUNT INT = 0,
		@Recordstatus char(1) = '' ,
		@Transcode decimal = 0,
		@Transdate datetime = null ,
		@Description varchar(100) = '' ,
		@Receivedtype varchar(10) = '' ,
		@Disbursement varchar(30) = '' ,
		@Paymenttype varchar(15) = '' ,
		@Edc varchar(10) = '' ,
		@Cardtype varchar(10) = '' ,
		@Chequeno varchar(30) = '' ,
		@Chequename varchar(50) = '' ,
		@Chequeduedate datetime = null ,
		@Currency varchar(10) = '' ,
		@Brand varchar(10) = '' ,
		@Channel varchar(30) = '' ,
		@Transtype varchar(50) = '' ,
		@Product varchar(30) = '' ,
		@Customertype varchar(10) = '' ,
		@Norekbank varchar(30) = '' ,
		@Remark varchar(100) = '' ,
		@Policyno varchar(30) = '' ,
		@Customercode varchar(10) = '' ,
		@Ci_Sys_No numeric(15,0) = 0,
		@RecordStatusActive  varchar(10) = dbo.getVariableValue('RECORD_ACTIVE'),
		@CpcType varchar(10) = dbo.getVariableValue('CPC_TYPE_PROFIT'),
		@Inv_Doc_No varchar(30) = '',
		@Inv_Sys_No numeric(15,0) = 0,
		@Inv_Type varchar(10) = '',
		@Bill_Code  VARCHAR(10) = '',
		@Adi_Sys_No NUMERIC(15,0) = 0,
		@Adi_Doc_No varchar(30) = '',
		@Ref_Type varchar(10) = '',
		@Ref_Total NUMERIC(17,4) = 0,
		@Ref_Ccy_Exch_Rate  numeric(17,4) = 0,
		@Wof_Sys_No NUMERIC(17,4) = 0,
		@TotalAmount numeric(17,4) = 0,
		@CustomerName varchar(150) = '',
		@Wof_Doc_No varchar(30) = '',
		@Di_Sys_No numeric(15,0) = 0,
		@Di_Doc_No varchar(30) = '',
		@Rfp_Sys_No NUMERIC(15,0) = 0,
		@Rfp_Doc_No varchar(30) = '',
		@Company_Name varchar(50) = '',
		@Acc_No varchar(10) = '',
		@Acc_Name varchar(50) = '',
		@Co_Sys_No numeric(15,0) = 0,
		@Co_Doc_No varchar(30) = '',
		--@Journal_Doc_No varchar(30) = '',
		@Balance_Type_Debit char(1) = '',
		@Balance_Type_Credit char(1) = '',
		@Total_Amount1 numeric(17,4) = 0,
		@Total_Credit_Amount numeric(17,4) = 0,
		@lineno varchar(10)
	
	IF ISNULL(@TransID,0) <> 0
	BEGIN

		SELECT 
				DISTINCT
				@RecordStatus = A.RecordStatus,
				@TransID = A.TransID,
				@TransDate = A.TransDate ,
				@TransCode = A.TransCode ,
				@ReceivedType = a.ReceivedType ,
				@Disbursement = a.Disbursement ,
				@PaymentType = a.PaymentType ,
				@EDC = a.EDC ,
				@CardType = a.CardType ,
				@Currency = a.Currency,
				@ChequeNo = a.ChequeNo ,
				@ChequeName = a.ChequeName,
				@ChequeDueDate = a.ChequeDueDate ,
				@Brand = a.Brand ,
				--@Channel = a.Channel ,
				--@TransType = a.TransType ,
				--@Product = a.Product ,
				--@CustomerType = b.CUSTOMER_TYPE ,
				--@NoRekBank = a.NoRekBank ,
				--@PolicyNo = A.PolicyNo,
				@CustomerCode = a.CustomerCode,
				@CustomerName = b.CUSTOMER_NAME
			FROM TransactionData01 A
			INNER JOIN gmCust0 B ON A.CustomerCode = B.CUSTOMER_CODE  			
			WHERE TransID = @TransID  
			
			SET @Src_Code = dbo.getVariableValue('SRC_DOC_CM_RFP') 
				
			PRINT 'CREATE DOCUMENT'	
					
			

			PRINT @RFP_Doc_No
			INSERT INTO ctRFP0 (    
							RECORD_STATUS ,    
							COMPANY_CODE ,    
							--RFP_SYS_NO ,
							RFP_DOC_NO,    
							RFP_STATUS ,    
							RFP_DATE ,    
							TRX_TYPE ,    
							VEHICLE_BRAND ,    
							CPC_TYPE ,    
							CPC_CODE ,    
							EXPECT_PAY_DATE ,    
							PAY_TO_SUPPLIER ,    
							PAY_TO_CUSTOMER ,    
							PAY_TO_EMPLOYEE ,    
							PAY_TYPE ,    
							PAYMENT_TO ,    
							PAY_TO_BANK_CODE ,    
							PAY_TO_BANK_BRANCH_CODE ,    
							PAY_TO_ACC_NO ,    
							PAY_TO_ACC_NAME , 
							CUST_SUPP_TYPE ,   
							RAK_COMPANY_CODE ,    
							BANK_ACC_TYPE ,    
							BANK_ACC_CODE ,    
							REMARK ,    
							TOTAL_AFTER_VAT ,    
							TOTAL_AFTER_VAT_BASE ,    
							PAID_IN_BASE ,
							VERIFIED_BY,
							VERIFIED_DATETIME,    
							APPROVAL_REQ_NO ,    
							APPROVAL_REQ_BY ,    
							APPROVAL_REQ_DATE ,    
							APPROVAL_LAST_BY ,    
							APPROVAL_LAST_DATE ,    
							APPROVAL_REMARK ,    
							PRINTING_NO ,    
							LAST_PRINT_BY ,    
							AP_CCY_CODE ,
							CHANGE_NO ,    
							CREATION_USER_ID ,    
							CREATION_DATETIME ,    
							CHANGE_USER_ID ,    
							CHANGE_DATETIME )    
						  VALUES (    
							@RecordStatusActive ,    
							@COMPANY_CODE ,    
							--RFP_SYS_NO ,
							@RFP_DOC_NO,    
							'10' ,    
							@Transdate  ,    
							@Trx_Type ,    
							@Brand ,    
							NULL,--CPC_TYPE ,    
							@Channel,--CPC_CODE ,    
							@Transdate ,--EXPECT_PAY_DATE ,    
							CASE WHEN @Transcode IN('201') THEN @COMPANY_CODE ELSE NULL END,--PAY_TO_SUPPLIER ,    
							CASE WHEN @Transcode IN('21','49','51','58','61','66','70') THEN @Customercode ELSE NULL END, --PAY_TO_CUSTOMER ,    
							NULL ,    
							@Disbursement ,    
							CASE WHEN @Transcode IN('201') THEN @Company_Name ELSE @CustomerName END,--PAYMENT_TO ,    
							'2014',--PAY_TO_BANK_CODE ,    
							null,--PAY_TO_BANK_BRANCH_CODE ,    
							@Acc_No ,--PAY_TO_ACC_NO ,    
							@Acc_Name ,--PAY_TO_ACC_NAME , 
							@Customertype,--CUST_SUPP_TYPE ,   
							@COMPANY_CODE ,--RAK_COMPANY_CODE ,    
							'B',--BANK_ACC_TYPE ,    
							@Norekbank,--BANK_ACC_CODE ,    
							@Policyno ,--+ '-' + CAST(@Transid AS VARCHAR(10)),--@Remark ,  
							@TotalAmount ,--TOTAL_AFTER_VAT ,    
							@TotalAmount,--TOTAL_AFTER_VAT_BASE ,    
							'I',--PAID_IN_BASE ,
							@CHANGE_USER_ID  ,
							GETDATE(),
							0,--APPROVAL_REQ_NO ,    
							'AUTO',--APPROVAL_REQ_BY ,    
							@Transdate ,--APPROVAL_REQ_DATE ,    
							'',--APPROVAL_LAST_BY ,    
							NULL,--APPROVAL_LAST_DATE ,    
							'',--APPROVAL_REMARK ,    
							0,--PRINTING_NO ,    
							'',--LAST_PRINT_BY ,    
							@Currency,--AP_CCY_CODE ,
							0,--CHANGE_NO ,    
							@CHANGE_USER_ID ,    
							GETDATE() ,    
							@CHANGE_USER_ID ,    
							GETDATE()
						)     
						
						SET @Rfp_Sys_No = SCOPE_IDENTITY()    
			  			
						--==generate ctRFP1==--    
						INSERT INTO ctRFP1 (    
							RECORD_STATUS ,    
							RFP_SYS_NO ,    
							RFP_LINE_NO ,    
							RFP_LINE_STAT ,    
							REF_TYPE ,    
							REF_SYS_NO ,    
							REF_DOC_NO ,    
							REF_LINE_NO ,    
							REF2_TYPE ,    
							REF2_SYS_NO ,    
							REF2_DOC_NO ,    
							REF2_LINE_NO ,    
							EVENT_NO ,    
							MODEL_CODE ,    
							JOB_TYPE ,    
							BILL_CODE ,    
							ITEM_CODE ,    
							DESCRIPTION ,    
							COST_ALLOC_CODE ,    
							CCY_CODE ,    
							CCY_RATE_TYPE ,    
							CCY_EXCH_RATE_DATE ,    
							CCY_EXCH_RATE ,    
							REF_TOTAL_AMOUNT ,    
							TOTAL_AFTER_VAT ,    
							TOTAL_AFTER_VAT_BASE_AMOUNT ,    
							REMARK ,    
							CHANGE_NO ,    
							CREATION_USER_ID ,    
							CREATION_DATETIME ,    
							CHANGE_USER_ID ,    
							CHANGE_DATETIME,
							TOTAL_PAYMENT ,
							TOTAL_PAYMENT_BASE_AMOUNT  )    
							SELECT 
							@RecordStatusActive  ,    
							@Rfp_Sys_No ,    
							a.[LineNo],--RFP_LINE_NO ,    
							'10',--RFP_LINE_STAT ,    
							'NRF',--REF_TYPE ,    
							0,--REF_SYS_NO ,    
							'',--REF_DOC_NO ,    
							0,--REF_LINE_NO ,    
							'',--REF2_TYPE ,    
							0,--REF2_SYS_NO ,    
							'',--REF2_DOC_NO ,    
							0,--REF2_LINE_NO ,    
							'',--EVENT_NO ,    
							'',--MODEL_CODE ,    
							'',--JOB_TYPE ,    
							'',--BILL_CODE ,    
							'',--ITEM_CODE ,    
							'',--DESCRIPTION ,    
							A.Product,--COST_ALLOC_CODE ,    
							@Currency ,--CCY_CODE ,    
							'BK',--CCY_RATE_TYPE ,    
							@Transdate,--CCY_EXCH_RATE_DATE ,    
							1,--CCY_EXCH_RATE ,    
							0,--REF_TOTAL_AMOUNT ,    
							a.Amount,-- TOTAL_AFTER_VAT ,    
							a.amount ,--TOTAL_AFTER_VAT_BASE_AMOUNT ,    
							a.policyno ,--+ '-' + CAST(@Transid AS VARCHAR(10)),--@Remark , ,    
							0,--CHANGE_NO ,    
							@CHANGE_USER_ID ,    
							GETDATE() ,    
							@Change_User_Id ,    
							GETDATE(),
							a.amount ,--TOTAL_PAYMENT,
							a.amount
							FROM TransactionData01 A
							left join comGenTable2 B ON B.TABLE_CODE = 'COAMAP' AND REPLACE(B.DESCRIPTION,' ','') = REPLACE(A.Description,' ','') 
							left JOIN lmCOA C ON B.TABLE_KEY0 = C.ACCOUNT_NO 
							INNER JOIN lmjournalmodel1 d on c.ACCOUNT_NO=d.ACC_NO
							WHERE TransID = @TransID and A.AMOUNT <> 0 and d.trx_type in ('O02','O08') and d.process_code='cmbo_d' and b.table_key1='1'
  
			SELECT
				@Total_Amount1 = ISNULL(SUM(TOTAL_AMOUNT),0)
			FROM CTRFP1 WITH (NOLOCK)
			WHERE RFP_SYS_NO = @RFP_Sys_No
			
			                                                                  
			UPDATE CTRFP0 WITH (ROWLOCK) SET
			TOTAL_after_vat = @Total_Amount1
			WHERE RFP_SYS_NO = @RFP_Sys_No
			
	END
   
END
