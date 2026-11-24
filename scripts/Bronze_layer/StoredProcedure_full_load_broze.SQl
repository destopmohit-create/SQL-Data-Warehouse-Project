/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema
    from external CSV files.

    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the BULK INSERT command to load data from CSV files into bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

===============================================================================
*/
create or alter PROCEDURE bronze.Load_Bronze as 
BEGIN
	DECLARE @start_time Datetime, @end_time datetime;
	DECLARE @batch_Start_Time Datetime, @batch_End_Time Datetime;
	BEGIN TRY
		print'=========================================================================='
		print'Loading Bronze Layer'
		print'=========================================================================='
		print'----------------------------Loading CRM Tables-----------------------------------'

		set @batch_Start_Time = getdate();
		set @start_time =getdate();
		print'<<<<<<<<<<<<<<<<<<Truncating Table bronze.crm_cust_info >>>>>>>>>>>>>>>>>';
		truncate table bronze.crm_cust_info ; --Used to refresh the entire table and best practice for Full Load
		print'<<<<<<<<<<<<<<<<<<Loading TAble bronze.crm_cust_info >>>>>>>>>>>>>>>>>';
		bulk insert bronze.crm_cust_info 
		from 'C:\Users\DELL\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_crm\cust_info.csv'
		with (
			FIRSTROW =2,
			FIELDTERMINATOR =',', --info in csv is seperated by ',' that's why we use
			TABLOCK --to lock the table and better performance
		);
		set @end_time =getdate();
		print'Loading Duration: '+cast(datediff(second,@start_time,@end_time)as nvarchar) +' seconds';
		print'-----------------------------------------------------------------------------------------------------------';
		
		set @start_time =getdate();
		print'<<<<<<<<<<<<<<<<<<Truncating Table bronze.crm_prd_info >>>>>>>>>>>>>>>>>';
		truncate table bronze.crm_prd_info ; --Used to refresh the entire table and best practice for Full Load
		print'<<<<<<<<<<<<<<<<<<Loading Table bronze.crm_prd_info >>>>>>>>>>>>>>>>>';
		bulk insert bronze.crm_prd_info 
		from 'C:\Users\DELL\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_crm\prd_info.csv'
		with (
			FIRSTROW =2,
			FIELDTERMINATOR =',', --info in csv is seperated by ',' that's why we use
			TABLOCK --to lock the table and better performance
		);
		set @end_time =getdate();
		print'Loading Duration: '+cast(datediff(second,@start_time,@end_time)as nvarchar) +' seconds';
	print'-----------------------------------------------------------------------------------------------------------';

		set @start_time =getdate();
		print'<<<<<<<<<<<<<<<<<<Truncating Table bronze.sales_details>>>>>>>>>>>>>>>>>';
		truncate table bronze.crm_sales_details ;--Used to refresh the entire table and best practice for Full Load
		print'<<<<<<<<<<<<<<<<<<Loading Table bronze.sales_details>>>>>>>>>>>>>>>>>>>>';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\DELL\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_crm\sales_details.csv'
		with (
			FIRSTROW =2,
			FIELDTERMINATOR =',', --info in csv is seperated by ',' that's why we use
			TABLOCK --to lock the table and better performance
		);
		set @end_time =getdate();
		print'Loading Duration: '+cast(datediff(second,@start_time,@end_time)as nvarchar) +' seconds';
		print'-----------------------------------------------------------------------------------------------------------';

		print'------------------Loading ERP Tables-----------------------------------';
		set @start_time =getdate();
		print'<<<<<<<<<<<<<<<<<<Truncating Table erp_cust_az12>>>>>>>>>>>>>>>>>';
		truncate table bronze.erp_cust_az12 ; --Used to refresh the entire table and best practice for Full Load
		print'<<<<<<<<<<<<<<<<<<Loading Table erp_cust_az12>>>>>>>>>>>>>>>>>>>>';
		bulk insert  bronze.erp_cust_az12 
		from 'C:\Users\DELL\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_erp\CUST_AZ12.csv'
		with (
			FIRSTROW =2,
			FIELDTERMINATOR =',', --info in csv is seperated by ',' that's why we use
			TABLOCK --to lock the table and better performance
		);
		set @end_time =getdate();
		print'Loading Duration: '+cast(datediff(second,@start_time,@end_time)as nvarchar) +' seconds';
		print'-----------------------------------------------------------------------------------------------------------';

		set @start_time =getdate();
		print'<<<<<<<<<<<<<<<<<<Truncating Table erp_loc_a101>>>>>>>>>>>>>>>>>';
		truncate table bronze.erp_loc_a101 ; --Used to refresh the entire table and best practice for Full Load
		print'<<<<<<<<<<<<<<<<<<Loading Table erp_loc_a101>>>>>>>>>>>>>>>>>>>>';
		bulk insert  bronze.erp_loc_a101
		from 'C:\Users\DELL\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_erp\LOC_A101.csv'
		with (
			FIRSTROW =2,
			FIELDTERMINATOR =',', --info in csv is seperated by ',' that's why we use
			TABLOCK --to lock the table and better performance
		);
		set @end_time =getdate();
		print'Loading Duration: '+cast(datediff(second,@start_time,@end_time)as nvarchar) +' seconds';
		print'-----------------------------------------------------------------------------------------------------------';

		set @start_time =getdate();
		print'<<<<<<<<<<<<<<<<<<Truncating Table erp_pax_cat_g1v2>>>>>>>>>>>>>>>>>';
		truncate table bronze.erp_pax_cat_g1v2 ; --Used to refresh the entire table and best practice for Full Load
		print'<<<<<<<<<<<<<<<<<<Loading Table erp_pax_cat_g1v2>>>>>>>>>>>>>>>>>';
		bulk insert  bronze.erp_pax_cat_g1v2
		from 'C:\Users\DELL\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\01_datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			FIRSTROW =2,
			FIELDTERMINATOR =',', --info in csv is seperated by ',' that's why we use
			TABLOCK --to lock the table and better performance
		);
		set @end_time =getdate();
		print'Loading Duration: '+cast(datediff(second,@start_time,@end_time)as nvarchar) +' seconds';
		print'-----------------------------------------------------------------------------------------------------------';
		set @batch_End_Time =GETDATE();
		print'<<<<<<<<<<<<<<<<<<<<<<Batch Loading Completed>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		print'Total Loading Duration: '+cast(datediff(second,@batch_Start_Time,@batch_End_Time)as nvarchar) +' seconds';

	end TRY
	BEGIN CATCH
		print'=========================================================================='
		print'<<<<<<<<<<<<<<<<<<<<ERROR OCURED DURING BRONZE LAYER>>>>>>>>>>>>>>>>>>>>>>'
		print'error message'+error_message();
		print'error message'+cast(error_number()as nvarchar);
		print'error message'+cast(error_state()as nvarchar);
		print'============================================================================'
	END CATCH
end
