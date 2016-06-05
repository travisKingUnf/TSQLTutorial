--NESTED TRANSACTIONS CONCEPTS SHOWED

BEGIN TRANSACTION Tran1

	PRINT @@TRANCOUNT

	BEGIN TRANSACTION Tran2

		PRINT @@TRANCOUNT

	COMMIT TRAN Tran2
	
	PRINT @@TRANCOUNT

COMMIT TRAN Tran1

PRINT '------------'

BEGIN TRANSACTION Tran1

	PRINT @@TRANCOUNT

	SAVE TRANSACTION SavePoint

		PRINT @@TRANCOUNT

	ROLLBACK TRAN SavePoint
	
	PRINT @@TRANCOUNT

COMMIT TRAN Tran1

PRINT '------------'

BEGIN TRANSACTION Tran1

	PRINT @@TRANCOUNT

	BEGIN TRANSACTION SavePoint

		PRINT @@TRANCOUNT

	COMMIT TRANSACTION SavePoint
	
	PRINT @@TRANCOUNT

	IF 1 = 2
		BEGIN
			ROLLBACK TRANSACTION Tran1
			PRINT 'TRAN1 ROLLBACK'
		END
	ELSE
		BEGIN
			COMMIT TRAN Tran1
			PRINT 'TRAN1 COMMITED'
		END